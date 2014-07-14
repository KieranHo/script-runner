{ScrollView} = require 'atom'
AnsiToHtml = require 'ansi-to-html'

module.exports =
class ScriptRunnerView extends ScrollView
  atom.deserializers.add(this)

  @deserialize: ({title, output, footer}) ->
    view = new ScriptRunnerView(title)
    view._output.html(output)
    view._footer.html(footer)
    view

  @content: ->
    @div class: 'script-runner', =>
      @h1 'Script Runner'
      @pre class: 'output'
      @div class: 'footer'

  constructor: (title) ->
    super
    @_output = @find('.output')
    @_footer = @find('.footer')
    @setTitle(title)

  serialize: ->
    deserializer: 'ScriptRunnerView'
    title: @title
    output: @_output.html()
    footer: @_footer.html()

  getTitle: ->
    "Script Runner: #{@title}"

  setTitle: (title) ->
    @title = title
    @find('h1').html(@getTitle())

  clear: ->
    @_output.html('')
    @_footer.html('')

  append: (text, className) ->
    span = document.createElement('span')
    node = document.createTextNode(text)
    span.appendChild(node)
    span.innerHTML = new AnsiToHtml().toHtml(span.innerHTML)
    span.className = className || 'stdout'
    @_output.append(span)

  footer: (text) ->
    @_footer.html(text)
