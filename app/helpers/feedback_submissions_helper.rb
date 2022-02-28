module FeedbackSubmissionsHelper
  
  def render_error_messages_if_present(feedback_submission, error_field)
    html_to_render = ''
    
    if error_field.present? && feedback_submission.errors.include?(error_field)
      html_to_render += '<div class="alert alert-danger attached-above">'
      html_to_render += '<ul>'
          html_to_render += '<li>' + feedback_submission.errors[error_field].join('</li><li>').html_safe + '</li>'
      html_to_render += '</ul>'
      html_to_render += '</div>'
    end
    
    return html_to_render.html_safe
  end
  
end
