class HtmlBuilder2
  def initialize(&block)
    @html = ""
    instance_eval(&block) if block_given?
  end

  def div(content= nil, &block)
    @html << "<div>"
    if block_given?
      block.call
    else
      @html << content.to_s
    end
    @html << "</div>"
  end

  def span(content = nil, &block)
    @html << "<span>"
    if block_given?
      block.call
    else
      @html << content.to_s
    end
    @html << "</span>"
  end

  def result
    @html
  end
end

builder = HtmlBuilder2.new do
  div do
    div "Conteúdo em div"
    span "Nota em div"
  end
  span "Nota de rodapé"
end
puts builder.result