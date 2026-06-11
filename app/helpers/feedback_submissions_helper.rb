module FeedbackSubmissionsHelper

  def render_error_messages_if_present(feedback_submission, error_field)
    puts "Checking for errors on field: #{error_field}"
    html_to_render = ''
    
    if error_field.present? && feedback_submission.errors.include?(error_field)
      puts "Rendering errors for #{error_field}: #{feedback_submission.errors[error_field].join(', ')}"
      html_to_render += '<div class="invalid-feedback">'
      html_to_render += '<p>'
          html_to_render += feedback_submission.errors[error_field].join('<br />').html_safe
      html_to_render += '</p>'
      html_to_render += '</div>'
    end
    
    return html_to_render.html_safe
  end
  
end
