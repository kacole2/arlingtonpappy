class Item < ActiveRecord::Base

	def self.scrape
		#We need Watir to click on JS links :(
		#This will only take a few second. We are running Headless with phantomjs
		browser = Watir::Browser.new :phantomjs

		browser.goto "https://www.arlingtonwine.net/websearch_results.html?kw=Winkle"
		browser.div(:id => "srcrz").wait_until_present
		pappysite = Item.find(1)

		if browser.div(:class => 'product-list').exists? == true
			STDOUT.write "There's Pappy!\n"
			pappysite.pappypresent = true
			pappysite.save

			if pappysite.ordersent == false
				pappysite.ordersent = true
				pappysite.save
				#Login to the site
				browser.goto "https://www.arlingtonwine.net/login.html"
				browser.text_field(:name => 'email').set(ENV["KENNY_ACCOUNT1_EMAIL"])
				browser.text_field(:name => 'pass').set(ENV["KENNY_ACCOUNT1_PW"])
				browser.form(:name => 'login').submit
				Watir::Wait.until { browser.url == "https://www.arlingtonwine.net/" }

				browser.goto "https://www.arlingtonwine.net/websearch_results.html?kw=Winkle"

				browser.div(:id => "srcrz").wait_until_present

				bourbons = browser.tables(:class => 'wf_content prow').each do |table|
					if table.text.include? "Winkle"
						add_to_cart = table.link :class => 'button'
						add_to_cart.click
					end
				end

				browser.goto "https://www.arlingtonwine.net/cart.html"
				browser.form(:id => "cartfrm").wait_until_present
				browser.radio(:id => "dlvr_shipto").set

				browser.text_field(:id => "shipzip_id").set('40206')
				sleep(2)
				browser.radio(:name => 'ship_weather').set

				proceed_to_checkout_button = browser.spans(:id => "prof_add").each do |span|
					if span.text == 'Proceed to Checkout'
						span.parent.click
					end
				end

				browser.div(:id => 'saved_bill_info').wait_until_present
				puts "made it to place order"
				browser.checkbox(:name, 'same').set
				browser.checkbox(:name, 'legal_age').set
				browser.span(:id => "placeorderid").parent.click
				STDOUT.write "Pappy order submitted!\n"
				

				def self.send_text(phonenumber, username)
					SMSEasy::Client.config['from_address'] = "ArlingtonPappy"
					ordercomplete_text = SMSEasy::Client.new
					ordercomplete_text.deliver(phonenumber,"at&t","Pappy Order for " + username.to_s + " is submitted!")
				end

				send_text(ENV["KENNY_NUMBER"], ENV["KENNY_ACCOUNT1_EMAIL"])
			end

		else
			STDOUT.write "No Pappy - trying again soon\n"
			pappysite.pappypresent = false
			pappysite.save
		end
		browser.close
	end

end
