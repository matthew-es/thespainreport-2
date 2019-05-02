class User < ApplicationRecord
	require 'bcrypt'
	has_secure_password
	
	validates :email, :uniqueness => {:case_sensitive => false}
	validates_format_of :email, :with => /@/, message: ": try your e-mail again…"
	validates :password_confirmation, :presence => true, :on => :create
	validates :password_confirmation, :presence => true, :on => :update, allow_blank: true
	
	scope :emails_all, -> {where(emails: 1)}
	scope :emails_full, -> {where(emails: [1, 2])}
	scope :emails_notes, -> {where(emails: [1, 2, 3])}
	scope :emails_english, -> {where(emaillanguage: [1, 3])}
   scope :emails_spanish, -> {where(emaillanguage: [2, 3])}
   scope :patrons, -> {where(role: 2)}

end