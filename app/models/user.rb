class User < ApplicationRecord
	require 'bcrypt'
	has_secure_password
	belongs_to :account, optional: true
	belongs_to :frame, optional: true
	
	validates :email, :uniqueness => {:case_sensitive => false, message: "—try your e-mail again…"}
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "—try your e-mail again…"
	validates :password, :presence => true, :on => [:create, :change_password], length: {minimum: 11, message: "—needs to be at least 11 characters long"}
	validates :password_confirmation, :presence => true, :on => [:create, :change_password]
	validates :password, :presence => true, :on => :update, length: {minimum: 11, message: "—needs to be at least 11 characters long"}, allow_blank: true
	validates :password_confirmation, :presence => true, :on => :update, allow_blank: true
	validate :password_complexity
	
	
	
	scope :emails_all, -> {where(emails: 1)}
	scope :emails_full, -> {where(emails: [1, 2])}
	scope :emails_notes, -> {where(emails: [1, 2, 3])}
	scope :emails_english, -> {where(emaillanguage: [1, 3])}
   scope :emails_spanish, -> {where(emaillanguage: [2, 3])}
   scope :english, -> {where(sitelanguage: 1)}
   scope :spanish, -> {where(sitelanguage: 2)}
   scope :patron, -> {where(status: 2)}
   scope :reader, -> {where(status: 3)}
   scope :account_owner, -> {where(account_role: 1)}
   scope :account_member, -> {where(account_role: 2)}
   
	def password_complexity
		if password.present? and not password.match(/^(?=.*[A-Z])./) and not password.match(/^(?=.*[\s])./)
	      errors.add :password, "—must include at least one capital letter and one space"
		elsif password.present? and not password.match(/^(?=.*[\s])./)
	      errors.add :password, "—must include at least one space"
		elsif password.present? and not password.match(/^(?=.*[A-Z])./)
	      errors.add :password, "—must include at least one capital letter"
		end
	end

end