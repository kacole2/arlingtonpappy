class ArlingtonPappyMailer < ActionMailer::Base
  default from: "ArlingtonPappy"

  def pappy()
    mail(:subject => "Pappy")
  end
end
