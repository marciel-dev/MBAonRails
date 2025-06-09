# Classe sem implementar Enumerable
# consumindo Enumerable direto da instancia do Array
class BetaSalesReport
  attr_reader :sales

  def initialize(sales = [])
    @sales = sales
  end

  def sales=(sale)
    @sales << sale if sale.kind_of?(Hash)
    @sales = @sales + sale if sale.kind_of?(Array)
  end

  def total_by_category
    total = []
    list_category.each do |category|
      total << {category: category, total_amount: total_amount_by_category(category)}
    end
    total
  end

  def top_sales(n)
    @sales.sort_by {|category| -category[:amount]}.take(n)
  end

  def above_average_sales
    @sales.select {|sale| sale[:amount] > avarege_sales}
  end
  def grouped_by_category
    @sales.group_by {|category| category[:category]}
  end

  private
  def list_category
    @sales.collect{|x| x[:category]}.uniq
  end

  def total_amount_by_category(category)
    @sales.select {|x| x[:category] == category }.sum{ |s| s[:amount]}
  end

  def avarege_sales
    @sales.sum {|amount| amount[:amount]} / @sales.length
  end
end

sales = [
  { product: "Notebook", category: "Eletrônicos", amount: 3000 },
  { product: "Celular", category: "Eletrônicos", amount: 1500 },
  { product: "Cadeira", category: "Móveis", amount: 500 },
  { product: "Mesa", category: "Móveis", amount: 1200 },
  { product: "Headphone", category: "Eletrônicos", amount: 300 },
  { product: "Armário", category: "Móveis", amount: 800 }
]


sales_report = BetaSalesReport.new()
sales_report.sales = sales
puts "----------TOTAL BY CATEGORY---------"
puts sales_report.total_by_category
puts "----------TOP SALES ----------"
puts sales_report.top_sales(2)
puts "----------GROUPED BY CATEGORY---------"
puts sales_report.grouped_by_category
puts "----------ABOVE AVAREGER SALES---------"
puts sales_report.above_average_sales
