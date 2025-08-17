require_relative 'prompts/task_time_estimator_prompt'

class OpenaiService
  include Prompts
  DEFAULT_MODEL = "gpt-4-turbo-preview"

  def self.estimate_task_time(title, description)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    prompt = Prompts::TASK_TIME_ESTIMATOR.dup
    prompt << "\n\nTitle: \"#{title}\"\nDescription: #{description.present? ? "\"#{description}\"" : "null"}"

    response = client.chat(
      parameters: {
        model: DEFAULT_MODEL,
        messages: [{ role: "user", content: prompt }],
      }
    )

    Rails.logger.info("OpenAI API Response: #{response.inspect}")
    
    estimated_hours = response.dig("choices", 0, "message", "content").to_f
    Rails.logger.info("Estimated hours: #{estimated_hours}")
    estimated_hours.positive? ? estimated_hours : nil
  rescue StandardError => e
    Rails.logger.error("Error estimating task time with OpenAI: #{e.message}")
    nil
  end
end