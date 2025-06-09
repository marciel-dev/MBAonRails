# Classe com enumerable implementada, consumindo direto de dentro do objeto instanciado
class SalesReport
  attr_reader :sales

  include Enumerable
  def initialize(sales = [])
    @sales = sales
  end

  def each(&block)
    @sales.each(&block)
  end

  def sales=(sale)
    @sales << sale if sale.kind_of?(Hash)
    @sales = @sales + sale if sale.kind_of?(Array)
  end

  def total_by_category
    total = []
    group_by {|category| category[:category]}.each do |k, v|
      total << { category: k, total_amount: v.sum {|category| category[:amount]} }
    end

    total
  end

  def top_sales(n)
    sort_by {|category| -category[:amount]}.take(n)
  end

  def above_average_sales
    select {|sale| sale[:amount] > avarege_sales}
  end
  def grouped_by_category
    group_by {|category| category[:category]}
  end

  private

  def avarege_sales
    sum {|amount| amount[:amount]} / count
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


sales_report = SalesReport.new(sales)
# sales_report.sales = sales
puts "----------TOTAL BY CATEGORY---------"
puts sales_report.total_by_category
puts "----------TOP SALES ----------"
puts sales_report.top_sales(2)
puts "----------GROUPED BY CATEGORY---------"
puts sales_report.grouped_by_category
puts "----------ABOVE AVAREGER SALES---------"
puts sales_report.above_average_sales
