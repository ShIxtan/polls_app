# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where(name: 'Varun').first_or_create!
User.where(name: 'Aaron').first_or_create!
User.where(name: 'Jeff').first_or_create!
User.where(name: 'CJ').first_or_create!
User.where(name: 'Ned').first_or_create!

Poll.where(title: "which Avengers Character are You?", author_id: 1 ).first_or_create!
Poll.where(title: "which Harry Potter Character are You?", author_id: 2 ).first_or_create!

Question.where(text: "what is your weapon of choice?", poll_id: 1).first_or_create!
Question.where(text: "favorite color?", poll_id: 1).first_or_create!
Question.where(text: "what is your favorite animal?", poll_id: 2).first_or_create!
Question.where(text: "what is your house?", poll_id: 2).first_or_create!

AnswerChoice.where(text: "Hammer", question_id: 1).first_or_create!
AnswerChoice.where(text: "Bow", question_id: 1).first_or_create!
AnswerChoice.where(text: "Tech", question_id: 1).first_or_create!
AnswerChoice.where(text: "Red", question_id: 2).first_or_create!
AnswerChoice.where(text: "Green", question_id: 2).first_or_create!
AnswerChoice.where(text: "Deer", question_id: 3).first_or_create!
AnswerChoice.where(text: "Otter", question_id: 3).first_or_create!
AnswerChoice.where(text: "Gryffindor", question_id: 4).first_or_create!
AnswerChoice.where(text: "Slytherin", question_id: 4).first_or_create!
AnswerChoice.where(text: "Hufflepuff", question_id: 4).first_or_create!
