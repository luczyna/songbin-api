require 'uri'

class HttpUrlValidator < ActiveModel::EachValidator
  def self.compliant?(value)
    uri = URI.parse(value)

    is_http = uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    has_host = !uri.host.nil?

    is_http && has_host
  rescue URI.InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    unless value.present? && self.class.compliant?(value)
      record.errors.add(attribute, "is not a valid HTTP(S) url")
    end
  end
end
