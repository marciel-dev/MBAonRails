class HtmlBuilder
  def initialize(&block)
    @html = ""
    instance_eval(&block) if block_given?
  end

  def div(content = nil, &block)
    @html << "<div>"
    if block_given?
      instance_eval(&block)
    else
      @html << content.to_s
    end
    @html << "</div>"
  end

  def span(content = nil, &block)
    @html << "<span>"
    if block_given?
      instance_eval(&block)
    else
      @html << content.to_s
    end
    @html << "</span>"
  end

  def result
    @html
  end
end

builder = HtmlBuilder.new do
  div do
    div "conteudo dentro da div"
    span "conteudo dentro da span, dentro da div a baixo da vid :p"
  end
  span "rodape?"
end

puts builder.result