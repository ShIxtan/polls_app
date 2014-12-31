# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many(
    :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :respondent_id,
    primary_key: :id
  )

  def completed_polls
    # Poll::find_by_sql([<<-SQL, self.id])
    #   SELECT
    #     polls.*, COUNT(distinct (questions.id)) c
    #   FROM
    #     polls
    #   LEFT OUTER JOIN
    #     questions ON poll_id = polls.id
    #   LEFT OUTER JOIN
    #     answer_choices ON question_id = questions.id
    #   LEFT OUTER JOIN
    #     (
    #       SELECT
    #         responses.*
    #       FROM
    #         responses
    #       WHERE
    #         respondent_id = ?
    #     ) r ON r.answer_id = answer_choices.id
    #   GROUP BY
    #     polls.id
    #   HAVING
    #     count(distinct(questions.id)) = count(r.id)
    # SQL

    Poll.select('polls.*, COUNT(distinct (questions.id)) c').
          joins('LEFT OUTER JOIN questions ON poll_id = polls.id').
          joins('LEFT OUTER JOIN answer_choices ON question_id = questions.id').
          joins("LEFT OUTER JOIN (select responses.* from responses where respondent_id = #{self.id}) r ON r.answer_id = answer_choices.id").
          group('polls.id').
          having('count(distinct(questions.id)) = count(r.id)')

  end

  def uncompleted_polls
    Poll.select('polls.*, COUNT(distinct (questions.id)) c').
      joins('LEFT OUTER JOIN questions ON poll_id = polls.id').
      joins('LEFT OUTER JOIN answer_choices ON question_id = questions.id').
      joins("LEFT OUTER JOIN (select responses.* from responses where respondent_id = #{self.id}) r ON r.answer_id = answer_choices.id").
      group('polls.id').
      having('count(distinct(questions.id)) != count(r.id)')
  end
end
