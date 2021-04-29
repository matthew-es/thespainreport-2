class User < ApplicationRecord
	require 'bcrypt'
	has_secure_password
	belongs_to :account, optional: true
	accepts_nested_attributes_for :account
	has_many :prints
	has_many :uploads, :through => :prints
	belongs_to :frame, optional: true
	belongs_to :subscription, optional: true
	
	validates :email, :uniqueness => {:case_sensitive => false, message: "—try your e-mail again…"}
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "—try your e-mail again…"
	validates :password, :presence => true, :on => [:create, :change_password], length: {minimum: 11, message: "—needs to be at least 11 characters long"}
	validates :password_confirmation, :presence => true, :on => [:create, :change_password]
	validates :password, :presence => true, :on => :update, length: {minimum: 11, message: "—needs to be at least 11 characters long"}, allow_blank: true
	validates :password_confirmation, :presence => true, :on => :update, allow_blank: true
	validate :password_complexity
	
	# enum status: { reader: 0, patron: 1, paused: 2, former: 3  }
	# enum accountrole: { owner: 0, member: 1 }
	
	scope :emails_all, -> {where(emails: 1)}
	scope :emails_full, -> {where(emails: [1, 2])}
	scope :emails_notes, -> {where(emails: [1, 2, 3])}
	
	scope :emails_english, -> {where(emaillanguage: [1, 3])}
   scope :emails_spanish, -> {where(emaillanguage: [2, 3])}
   
   scope :english, -> {where(sitelanguage: 1)}
   scope :spanish, -> {where(sitelanguage: 2)}
   
   scope :authors, -> {where(status: 1)}
   scope :super_patrons, -> {where(status: 4)}
   scope :patrons, -> {where(status: 2)}
   scope :uptodate, -> {User.joins(:account).merge(Account.uptodate)}
   scope :declined, -> {User.joins(:account).merge(Account.declined)}
   scope :cancelled, -> {User.joins(:account).merge(Account.cancelled)}
   scope :readers, -> {where(status: 3)}
   
   
   scope :bosses, -> {where(account_role: 1)}
   scope :members, -> {where(account_role: 2)}
   
   scope :nil_status, -> {where(status: nil)}
   
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