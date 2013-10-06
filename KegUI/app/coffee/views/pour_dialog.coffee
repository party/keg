View = require('coffee/views/view')


class PourDialog extends View

  template: require('html/pour_dialog')
  successTemplate: require('html/pour_success')
  errorTemplate: require('html/pour_error')

  render: =>
    super
    vex.open {content: @$el}
    @

  updatePour: (oz) =>
    @$('#amount').text oz

  showPourComplete: =>
    @_showMessage @successTemplate

  showPourError: =>
    @_showMessage @errorTemplate

  _showMessage: (template) =>
    @$el.html template()

  close: =>
    vex.close()


module.exports = PourDialog
