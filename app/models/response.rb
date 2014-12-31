# == Schema Information
#
# Table name: responses
#
#  id            :integer          not null, primary key
#  answer_id     :integer
#  respondent_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Response < ActiveRecord::Base
  validate :respondent_has_not_already_answered_question, :respondent_is_not_author

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :respondent_id,
    primary_key: :id
  )

  belongs_to(
   :answer_choice,
   class_name: 'AnswerChoice',
   foreign_key: :answer_id,
   primary_key: :id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  has_many(
    :siblings,
    through: :question,
    source: :responses
  )

  def sibling_responses
    siblings.where('responses.id != ? or ? is null', id, id)
  end

  private
  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(respondent_id: respondent_id)
      errors[:respondent_id] << "you have already answered this question!"
    end
  end

  def respondent_is_not_author
    poll = Poll.joins(:questions).joins(:answer_choices).where("answer_choices.id = ?", answer_id)

    if poll.first.author_id == respondent_id
      errors[:respondent_id] << "you are the author of this poll!"
    end
  end
end
