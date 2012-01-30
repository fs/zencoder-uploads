class Uploader
  constructor: (form) ->
    @allowedTypes = ["video/quicktime", "video/avi", "video/mp4"]

    file = $("input:file", form)
    file.change @fileChanged
    file.attr "accept", @allowedTypes.join ", "
    @file = file[0]

    form.submit @formSubmitted
    @url = form.attr("action") + ".json"
    @form = form[0]

    @button = $("input[type=submit]", form)
    @disable()

  disable: ->
    @enabled = false
    @button.attr("disabled", true)

  enable: ->
    $("#status").text("").hide()
    @enabled = true
    @button.attr("disabled", false)

  fileChanged: (e) =>
    if $.inArray(@file.files[0].type, @allowedTypes) > -1
      @enable()
    else
      @complete("You can only upload .mov or .avi files")

  formSubmitted: (e) =>
    return false unless @enabled
    @openProgress()
    @sendRequest()
    e.preventDefault()

  openProgress: ->
    $.facebox(div: '#progress')

  sendRequest: ->
    xhr = new XMLHttpRequest
    xhr.upload.addEventListener "progress", @updateProgress, false
    xhr.addEventListener "load", @uploaded, false
    xhr.addEventListener "error", @failed, false
    xhr.addEventListener "abort", @cancelled, false
    xhr.open "POST", @url
    xhr.send @formData()

  formData: ->
    fd = new FormData
    fd.append "authenticity_token", @csrfToken()
    fd.append "video[original_file]", @file.files[0]
    fd

  csrfToken: ->
    $('meta[name=csrf-token]').attr "content"

  updateProgress: (e) =>
    percent = Math.round(e.loaded * 100 / e.total)
    $("#progressbar .bar").css "width", "#{percent}%"
    $("#progressbar .label").text "#{percent}%"

  uploaded: (e) =>
    if e.target.status == 200
      @succeeded(e)
    else
      @failed(e)

  succeeded: (e) =>
    @complete "Successfully uploaded video."

  failed: (e) =>
    @complete "Upload failed."

  cancelled: (e) =>
    @complete "You have cancelled your upload"

  complete: (status) ->
    @form.reset()
    @disable()
    $.facebox.close()
    $("#progressbar .bar").css "width", "0"
    $("#progressbar .label").text ""
    $("#status").text(status).show()

jQuery ($) ->
  new Uploader($("#uploader"))

