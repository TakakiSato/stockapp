class StockCodesList
  require 'open-uri'
  require 'nokogiri'

  def getStockDetailURL
    @stockCode=[]
    #テスト用コード
    #pg = 1
    #テスト時コメントアウト
    for pg in 1..8 do
      # スクレイピング先のURL
      url = "http://info.finance.yahoo.co.jp/ranking/?kd=31&tm=d&vl=a&mk=3&p=#{pg}"
      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      # htmlをパース(解析)してオブジェクトを作成
      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.xpath('//td[@class="txtcenter"]/a').each do |node|
      #売買代金上位の銘柄コードを取得
        @stockCode.push(node.inner_text)
      end
    #テスト時コメントアウト
    end
    return @stockCode
  end
end