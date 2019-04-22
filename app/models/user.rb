class User < ApplicationRecord
	require 'bcrypt'
	has_secure_password
	
	validates :email, :uniqueness => {:case_sensitive => false}
	validates_format_of :email, :with => /@/, message: ": try your e-mail again…"
	validates :password_confirmation, :presence => true, :on => :create
	validates :password_confirmation, :presence => true, :on => :update, allow_blank: true
	
	scope :emailsall, -> {where(emails: 1)}
	scope :emailsfull, -> {where(emails: [1, 2])}
	scope :emailsenglish, -> {where(emaillanguage: [1, 3])}
   scope :emailsspanish, -> {where(emaillanguage: [2, 3])}
end