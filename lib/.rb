require 'stocks_list'
require 'good_stocks_list'

class Task::GetGoodStockList
  def self.execute
    #StocksListクラスをnew
    stocksList=StocksList.new
    #株の詳細画面へのURLを取得する。
    stockRankingURL=stocksList.getStockDetailURL()
   　#取得したURLを配列に変換する。
    stockRankingURLList=stocksList.(stockRankingURL)
  end

end