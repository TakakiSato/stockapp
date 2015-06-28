class StockDetailsList
  require 'open-uri'
  require 'nokogiri'

  def accessStockDetail(stockCodes)
    stockDetails=Hash.new
    #日付取得
    d=Date.today
    #3か月前
    threeManAgo=d<<3
    #Stringに
    d=d.strftime("%Y%m%d").to_s
    threeManAgo=threeManAgo.strftime("%Y%m%d").to_s
    #テスト用コード
    #for stocknum in 0..1 do
      #テスト時コメントアウト
      for stocknum in 0..stockCodes.length-1 do
      eval("CD#{stockCodes[stocknum]}=Array.new")
      for pagenum in 1..3 do
        @accessURL="http://info.finance.yahoo.co.jp/history/?code=#{stockCodes[stocknum]}.T&sy=#{threeManAgo[0,4]}&sm=#{threeManAgo[5]}&sd=#{threeManAgo[6,2]}&ey=#{d[0,4]}&em=#{d[5]}&ed=#{d[6,2]}&tm=d&p=#{pagenum}"
        @getObject="//div[@class=\"padT12 marB10 clearFix\"]/table[@class=\"boardFin yjSt marB6\"]/tr/td"
        #個別の株価データのリストをnewする。
        charset = nil
        #　銘柄コードの一覧をもとに順次株詳細画面へアクセスする。
        html = open(@accessURL) do |f|
          charset = f.charset # 文字種別を取得
          f.read # htmlを読み込んで変数htmlに渡す
        end

        # htmlをパース(解析)してオブジェクトを作成
        doc = Nokogiri::HTML.parse(html, nil, charset)
        #各銘柄の日付ごとの始値 高値  安値  終値  を20日分取得する
        doc.xpath(@getObject).each do |node|
          eval("CD#{stockCodes[stocknum]}").push(node.inner_text)
        end
        sleep(1)
        stockDetails.store("CD#{stockCodes[stocknum]}" ,eval("CD#{stockCodes[stocknum]}"))
      end
    end
    return stockDetails
  end

  def getAssessmentStock(stockDetails ,stockCodes)

    
    
    #戻り値用のハッシュをnew
    stockAssesmentData=Hash.new
    p stockCodes
    p stockDetails
    #テスト用コード
    #num = 0
    #テスト時コメントアウト
    for num in 0..stockCodes.length-1 do
    #銘柄ごとの始値、高値、低値、終値を格納する配列をnew
    eval("@CD#{stockCodes[num]}openingPriceList=Array.new")
    eval("@CD#{stockCodes[num]}highPriceList=Array.new")
    eval("@CD#{stockCodes[num]}lowPriceList=Array.new")
    eval("@CD#{stockCodes[num]}closingPriceList=Array.new")
    eval("@CD#{stockCodes[num]}volumeList=Array.new")
    # 銘柄の３か月間分のデータをハッシュから取り出す。
    stockDetail=stockDetails["CD#{stockCodes[num]}"]
    p "CD#{stockCodes[num]}"
    p stockDetail
    p stockDetail.length
    #IPO株チェック
      if stockDetail.length <= 419 then
        next
      end
    for subnum in 1..stockDetail.length-1 do
      #始値を配列に投入する。
      if subnum % 7 == 1 then
        eval("@CD#{stockCodes[num]}openingPriceList.push(stockDetail[subnum].gsub(\",\",'').to_i)")
      #高値を配列に投入する。
      elsif subnum % 7 == 2 then
        eval("@CD#{stockCodes[num]}highPriceList.push(stockDetail[subnum].gsub(\",\",'').to_i)")
      #低値を配列に投入する。
      elsif subnum % 7 == 3 then
        eval("@CD#{stockCodes[num]}lowPriceList.push(stockDetail[subnum].gsub(\",\" ,'').to_i)")
      #終値を配列に投入する。
      elsif subnum % 7 == 4 then
        eval("@CD#{stockCodes[num]}closingPriceList.push(stockDetail[subnum].gsub(\",\",'').to_i)")
      #出来高を配列に投入する。
      elsif subnum % 7 == 5 then
        eval("@CD#{stockCodes[num]}volumeList.push(stockDetail[subnum].gsub(\",\",'').to_i)")
      end
    end
    #始値、高値、低値、終値の20日間平均、最高値、最安値を取得する、
    #type=eval("[@CD#{stockCodes[num]}openingPriceList,@CD#{stockCodes[num]}highPriceList,@CD#{stockCodes[num]}lowPriceList,@CD#{stockCodes[num]}closingPriceList,@CD#{stockCodes[num]}volumeList]")
    eval("@CD#{stockCodes[num]}av25List=Array.new")
    type=eval("[@CD#{stockCodes[num]}openingPriceList,@CD#{stockCodes[num]}highPriceList,@CD#{stockCodes[num]}lowPriceList,@CD#{stockCodes[num]}closingPriceList,@CD#{stockCodes[num]}volumeList,@CD#{stockCodes[num]}av25List]")
    #typeStr=["@openingPriceList","@highPriceList","@lowPriceList","@closingPriceList"]
    for typenum in 0..4
      type[typenum].push(type[typenum].inject(0.0){|r,i| r+=i }/type[typenum].size)
    #type[typenum].push(type[typenum].max)
    #type[typenum].push(type[typenum].min)
    end
    #25日平均産出
      for av25Linenum in 0..15
        av25LinenumEnd=av25Linenum+24
        tmpClosingList=Array.new
        eval("tmpClosingList=@CD#{stockCodes[num]}closingPriceList[av25Linenum..av25LinenumEnd]")
        p tmpClosingList
        eval("type[5].push(tmpClosingList.inject(0.0){|r,i| r+=i }/tmpClosingList.size)")
      end
    stockAssesmentData.store("@CD#{stockCodes[num]}openingPriceList" ,eval("@CD#{stockCodes[num]}openingPriceList"))
    stockAssesmentData.store("@CD#{stockCodes[num]}highPriceList" ,eval("@CD#{stockCodes[num]}highPriceList"))
    stockAssesmentData.store("@CD#{stockCodes[num]}lowPriceList" ,eval("@CD#{stockCodes[num]}lowPriceList"))
    stockAssesmentData.store("@CD#{stockCodes[num]}closingPriceList" ,eval("@CD#{stockCodes[num]}closingPriceList"))
    stockAssesmentData.store("@CD#{stockCodes[num]}volumeList" ,eval("@CD#{stockCodes[num]}volumeList"))
    stockAssesmentData.store("@CD#{stockCodes[num]}av25List" ,eval("@CD#{stockCodes[num]}av25List"))

    #テストの際はコメントアウト
    end
    return stockAssesmentData
  end
end
