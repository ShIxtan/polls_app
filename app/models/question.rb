# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :string           not null
#  poll_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  validates :text, presence: true

  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id,
    dependent: :destroy
  )

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  def results
    result = Hash.new
    # answer_choices.includes(:responses).each do |choice|
    #   result[choice.text] = choice.responses.length
    # end

    # answer_choices.find_by_sql(<<-SQL)
    #   SELECT
    #     answer_choices.text, COUNT(responses.id) c
    #   FROM
    #     answer_choices
    #   LEFT OUTER JOIN
    #     responses ON answer_choices.id = responses.answer_id
    #   WHERE
    #     answer_choices.question_id = #{self.id}
    #   GROUP BY
    #     answer_choices.id
    # SQL

    choices = answer_choices.select('answer_choices.text AS t', 'count(responses.id) AS c').
      joins('LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_id').
        where({question_id: id}).
          group('answer_choices.id')

    choices.each do |choice|
      result[choice.t] = choice.c
    end

    result
  end

end
