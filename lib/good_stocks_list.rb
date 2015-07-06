class GoodStocksList
  require "date"

  def assessmentStock(stockAssesmentDataes,stockCodeList)
    #テスト用コード
    #code = 0
    for code in 0..stockCodeList.length-1 do
      #処理中断Flug
      nextFlug = 0
      #株価コード
      stockCodes = stockCodeList[code]
      #------------------------parameter set end--------------------------------------
      #メソッド呼び出し
      nextFlug=granbill1(stockCodes,stockAssesmentDataes["@CD#{stockCodes}closingPriceList"],stockAssesmentDataes["@CD#{stockCodes}openingPriceList"],stockAssesmentDataes["@CD#{stockCodes}lowPriceList"],stockAssesmentDataes["@CD#{stockCodes}highPriceList"],stockAssesmentDataes["@CD#{stockCodes}volumeList"],stockAssesmentDataes["@CD#{stockCodes}av25List"])
      if nextFlug == 1 then
      #テスト時コメントアウト
      next
      end

      nextFlug=granbill2(stockCodes,stockAssesmentDataes["@CD#{stockCodes}closingPriceList"],stockAssesmentDataes["@CD#{stockCodes}openingPriceList"],stockAssesmentDataes["@CD#{stockCodes}lowPriceList"],stockAssesmentDataes["@CD#{stockCodes}highPriceList"],stockAssesmentDataes["@CD#{stockCodes}volumeList"],stockAssesmentDataes["@CD#{stockCodes}av25List"])
      if nextFlug == 1 then
      #テスト時コメントアウト
      next
      end

      #nextFlug=onlyCandle(stockCodes,stockAssesmentDataes["@CD#{stockCodes}closingPriceList"],stockAssesmentDataes["@CD#{stockCodes}openingPriceList"],stockAssesmentDataes["@CD#{stockCodes}lowPriceList"],stockAssesmentDataes["@CD#{stockCodes}highPriceList"],stockAssesmentDataes["@CD#{stockCodes}volumeList"])
      nextFlug=granbill3(stockCodes,stockAssesmentDataes["@CD#{stockCodes}closingPriceList"],stockAssesmentDataes["@CD#{stockCodes}openingPriceList"],stockAssesmentDataes["@CD#{stockCodes}lowPriceList"],stockAssesmentDataes["@CD#{stockCodes}highPriceList"],stockAssesmentDataes["@CD#{stockCodes}volumeList"],stockAssesmentDataes["@CD#{stockCodes}av25List"])
      if nextFlug == 1 then
      #テスト時コメントアウト
      next
      end

    #nextFlug=lows(stockCodes,"@CD#{stockCodes}closingPriceList","@CD#{stockCodes}openingPriceList","@CD#{stockCodes}lowPriceList","@CD#{stockCodes}highPriceList","@CD#{stockCodes}volumeList")
    #テスト時コメントアウト
    end
  end

  def granbill1(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,av25List)
    #基準日
    #for referenceDate in 0..5 do
    referenceDate=0
      #基準日から過去10日間から前日の移動平均線が下落中であることをチェックする。
      
      for compareDateRefrence in 1..9 do
        compareDate=referenceDate+compareDateRefrence
        if av25List[compareDate] >= av25List[compareDate+1] then
        break
        end
        avarageFlug=compareDateRefrence
      end
      #過去平均の条件を満たす場合、ローソク足の評価をする。
      if avarageFlug==9 then
        #当日は移動平均線が上昇を示してることをチェックする。
        if av25List[referenceDate] >= av25List[referenceDate+1] then
        #参照日の高値が25日平均を超えていること
          if av25List[referenceDate] < highPriceList[referenceDate] then
            nextFlug=candleCheck(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,"granbill1")
            #条件に合致する銘柄だった場合、処理を中断して、nextFlugを返す。
            ##p nextFlug
            if nextFlug==1
              return nextFlug
            end
          end
        end
      end
    #end
  end

  def granbill2(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,av25List)
    #基準日
    #for referenceDate in 0..5 do
      referenceDate=0
      #基準日から過去10日間の25日平均線が上昇を示していることをチェックする。
      for compareDateRefrence in 1..9 do
        compareDate=referenceDate+compareDateRefrence
        if av25List[compareDate] <= av25List[compareDate+1] then
         break
        end
        avarageFlug=compareDateRefrence
      end
      #過去平均の条件を満たす場合、ローソク足の評価をする。
      if avarageFlug==9 then
        ##p stockCodes
        #参照日の安値が25日平均を下回ること
        if lowPriceList[referenceDate] < av25List[referenceDate] then
          nextFlug=candleCheck(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,"granbill2")
        #条件に合致する銘柄だった場合、処理を中断して、nextFlugを返す。
        end
        ##p nextFlug
        if nextFlug==1
          return nextFlug
        end
      end
    #end
  end

  def granbill3(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,av25List)
    #基準日
    #for referenceDate in 0..5 do
    referenceDate=0
      #基準日から過去15日間の終値が平均より上であることをチェックする。
      for compareDateRefrence in 1..9 do
        compareDate=referenceDate+compareDateRefrence
        if av25List[compareDate] <= av25List[compareDate+1] then
          break
        end
        avarageFlug=compareDateRefrence
      end
      #過去平均の条件を満たす場合、ローソク足の評価をする。
      if avarageFlug==9 then
        ##p stockCodes
        #当日の安値が平均の1.02倍以下であること(移動平均線付近まで下落した)
        if lowPriceList[referenceDate] < av25List[referenceDate]*1.02 then
          #当日の安値が移動平均線を割っていないこと
          if av25List[referenceDate] < lowPriceList[referenceDate] then
            nextFlug=candleCheck(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,"granbill3")
          #条件に合致する銘柄だった場合、処理を中断して、nextFlugを返す。
          end
        end
        ##p nextFlug
        if nextFlug==1
        return nextFlug
        end
      end

    #end
  end

  #  def onlyCandle(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList)
  #    #基準日
  #    for referenceDate in 0..5 do
  #      nextFlug=candleCheck(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,"onlyCandle")
  #      #条件に合致する銘柄だった場合、処理を中断して、nextFlugを返す。
  #      ##p nextFlug
  #      if nextFlug==1
  #      return nextFlug
  #      end
  #    end
  #  end

  def candleCheck(stockCodes,closingPriceList,openingPriceList,lowPriceList,highPriceList,volumeList,type)
    #基準日
    for referenceDate in 0..3 do
      #たくり線
      #基準日が陽線である
      if openingPriceList[referenceDate] < closingPriceList[referenceDate]
        #陽線か陰線か。
        if openingPriceList[referenceDate+1] < closingPriceList[referenceDate+1]
        lowPriceActual=openingPriceList[referenceDate+1]
        highPriceActual=closingPriceList[referenceDate+1]
        else
        lowPriceActual=closingPriceList[referenceDate+1]
        highPriceActual=openingPriceList[referenceDate+1]
        end
        #始値終値の値幅確認
        priceRange=openingPriceList[referenceDate+1] - closingPriceList[referenceDate+1]
        #mustache ひげ
        underMustache=lowPriceActual - lowPriceList[referenceDate+1]
        overMustache=highPriceList[referenceDate+1] - highPriceActual
        #下ひげの長い線であること
        if priceRange.abs*5 < underMustache
          #上ひげが短い線であること
          if overMustache < priceRange.abs
            logprint(stockCodes,"#{type}_Takuri_Geraku",referenceDate)
          return 1
          end
        end
      end

      #      #抱きの一本
      #      #前日が陰線
      #      if closingPriceList[referenceDate+1] < openingPriceList[referenceDate+1]
      #        #当日始値が前日終わりより低い価格
      #        if openingPriceList[referenceDate] < closingPriceList[referenceDate+1]
      #          #陽線であること
      #          if openingPriceList[referenceDate] < closingPriceList[referenceDate]
      #            priceRange = closingPriceList[referenceDate] - openingPriceList[referenceDate]
      #            tagetGrowthRate = closingPriceList[referenceDate]*0.05
      #            #大陽線であること
      #            if tagetGrowthRate < priceRange
      #              logprint(stockCodes,"#{type}_Daki",referenceDate)
      #            return 1
      #            end
      #          end
      #        end
      #      end
      #
      #      #寄り切り線
      #      if openingPriceList[referenceDate] == lowPriceList[referenceDate]
      #        #陽線であること
      #        if openingPriceList[referenceDate] < closingPriceList[referenceDate]
      #          priceRange = closingPriceList[referenceDate] - openingPriceList[referenceDate]
      #          tagetGrowthRate = closingPriceList[referenceDate]*0.05
      #          #大陽線
      #          if tagetGrowthRate < priceRange
      #            logprint(stockCodes,"#{type}_Yorikiri",referenceDate)
      #          return 1
      #          end
      #        end
      #      end

      #大陽線
      #陽線であること
      if openingPriceList[referenceDate] < closingPriceList[referenceDate]
        priceRange = closingPriceList[referenceDate] - openingPriceList[referenceDate]
        tagetGrowthRate = closingPriceList[referenceDate]*0.03
        #大陽線
        if tagetGrowthRate < priceRange
          logprint(stockCodes,"#{type}_Daiyousen",referenceDate)
        return 1
        end
      end

      #明けの明星
      #二日前が陰線であること
      if closingPriceList[referenceDate+2] < openingPriceList[referenceDate+2]
        #一日前窓を開けて下落すること
        if highPriceList[referenceDate+1] < lowPriceList[referenceDate+2]
          #if closingPriceList[referenceDate+1] < closingPriceList[referenceDate+2]
          #当日窓を開けて上昇
          if highPriceList[referenceDate+1] < lowPriceList[referenceDate]
            #if openingPriceList[referenceDate+1] < openingPriceList[referenceDate]
            if openingPriceList[referenceDate] < closingPriceList[referenceDate]
              logprint(stockCodes,"#{type}_Ake",referenceDate)
            return 1
            end
          #end
          end
        #end
        end
      end

      #赤三兵
      #二日前が陽線である
      if openingPriceList[referenceDate+2] < closingPriceList[referenceDate+2]
        #一日前が陽線である
        if openingPriceList[referenceDate+1] < closingPriceList[referenceDate+1]
          #二日前の終値より、一日前の終値が高い
          if closingPriceList[referenceDate+2] < closingPriceList[referenceDate+1]
            #一日前の始値より、二日前の終値が高い
            if openingPriceList[referenceDate+1] < closingPriceList[referenceDate+2]
              #当日が陽線である。
              if openingPriceList[referenceDate] < closingPriceList[referenceDate]
                #一日前の終値より、当日の終値が高い
                if closingPriceList[referenceDate+1] < closingPriceList[referenceDate]
                  #当日の始値より、一日前の終値が高い
                  if openingPriceList[referenceDate] < closingPriceList[referenceDate+1]
                    logprint(stockCodes,"#{type}_Akasanpei_Geraku",referenceDate)
                  return 1
                  end
                end
              end
            end
          end
        end
      end

      #陽の差し込み線
      #前日が陰線である
      if closingPriceList[referenceDate+1] < openingPriceList[referenceDate+1]
      priceRange = openingPriceList[referenceDate+1] - closingPriceList[referenceDate+1]
        tagetGrowthRate = closingPriceList[referenceDate]*0.03
        #大陰線
        if tagetGrowthRate < priceRange

        #当日が陽線である。
          if openingPriceList[referenceDate] < closingPriceList[referenceDate]
          #前日終値より当日終値が高いこと
            if closingPriceList[referenceDate+1] < closingPriceList[referenceDate]
            #前日終値より当日始値が低いこと
              if openingPriceList[referenceDate] < closingPriceList[referenceDate+1]
              #前日初値より当日終値が低いこと
                if closingPriceList[referenceDate] < openingPriceList[referenceDate+1]

                  logprint(stockCodes,"#{type}_Sasikomi",referenceDate)
                  return 1
                end
              end
            end
          end
        end
      end
      #上げ三方仕掛け
      #三日前が陽線である
      if openingPriceList[referenceDate+3] < closingPriceList[referenceDate+3]
        #二日前の始値が三日前の終値より低い
        if openingPriceList[referenceDate+2] < closingPriceList[referenceDate+3]
          #二日前が陰線
          if closingPriceList[referenceDate+2] < openingPriceList[referenceDate+2]
            #二日前の終値が三日前の終値より低い
            if closingPriceList[referenceDate+2] < closingPriceList[referenceDate+3]
              #二日前の始値が三日前の終値より低い
              if openingPriceList[referenceDate+1] < closingPriceList[referenceDate+2]
                #一日前が陰線
                if closingPriceList[referenceDate+1] < openingPriceList[referenceDate+1]
                  #一日前の終値が二日前の終値より低い
                  if closingPriceList[referenceDate+1] < closingPriceList[referenceDate+2]
                    #一日前の始値が二日前の終値より低い
                    if openingPriceList[referenceDate+1] < closingPriceList[referenceDate+2]
                      #当日が陰線
                      if closingPriceList[referenceDate] < openingPriceList[referenceDate]
                        #当日の終値が一日前の終値より低い
                        if closingPriceList[referenceDate] < closingPriceList[referenceDate+1]
                          logprint(stockCodes,"#{type}_agesanpo",referenceDate)
                        return 1
                        end 
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def logprint(stockCodes,type,referenceDate)
    d=Date.today
    d=d.strftime("%Y%m%d").to_i
    f=File.open("./app/assets/#{type}#{d}.txt", 'a') # wは書き込み権限
    f.puts("#{d-referenceDate}\t#{stockCodes}\t #{type} ")
    f.close
  end
end