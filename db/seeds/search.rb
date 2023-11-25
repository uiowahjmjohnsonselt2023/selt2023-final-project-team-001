seller_ids = User.sellers.pluck(:id)

# Seeds for testing search functionality.
defaults = {
  seller_id: Faker::Base.sample(seller_ids),
  quantity: 1,
  condition: "fair",
  private: false
}
ipod_touches_hashes = [
  {
    name: "Used Apple iPod touch 3rd Generation 32 GB Black Read",
    price_cents: 23_00,
    description: <<~PRODUCT_DESCRIPTION
      IPOD TOUCH 3rd GENERATION -32GB - BLACK
      !Read Description!
      this old model device it Cant support on App Store or iCloud anymore
      other basic functions are working condition，Idea connect devices to computer’s iTunes and sync song to the iPad
      
      *PLEASE NOTE: IPOD TOUCH 3rd GENERATION ONLY SUPPORTS IOS UP TO 5
      
      FUNCTIONALITY:
      *This device has been reset to factory settings*
      
      CONDITION:
      Front screen: some scratches
      Back panel: Heavy scratches
      
      WHAT’S INCLUDED:
      iPod
      
      FREE 1x charging cable NOT OEM RANDOM COLOR/MODEL
      OUR STORE HAS LOT OF IPOD TOUCH FOR SALE ,YOU CAN CLICK See other items to find it.
    PRODUCT_DESCRIPTION
  },
  {
    name: "Apple iPod touch 3rd Generation Silver",
    price_cents: 22_49,
    description: "Apple iPod touch 3rd Generation Silver. Condition is Used. Shipped with USPS Ground Advantage."
  },
  {
    name: "Apple iPod Touch 2nd 3rd 4th Generation 8GB 16GB 32GB 64GB Read",
    price_cents: 22_00,
    description: <<~PRODUCT_DESCRIPTION
      All units will bundled with a charging cable
      old model device it Cant support iCloud or App Store 
      other basic functions are working condition，Idea connect devices to computer’s iTunes and sync song to the iPod for music player
      
      ipod touch 2nd no camera
      ipod touch 3rd no camera
      ipodtouch 4th have front and rear cameras
      
      included :
                     1x Used Apple IPOD touch
                      1x charging cable ( not oem )
      
      Condition :
          
                  Screen will show some signs of normal use in around B/C condition
                  Back cover will show some to lot scratches
      
      tested in fully working condition :( wifi bluetooth ,cameras,touch screen ,all buttons, headphone jack,charging port and battery）
      
      ipod touch 3rd will only support up to ios5
      iPod Touch 4 will only support apps up to IOS 6
      Therefore the apps request higher are not support on this iPod
      
      OUR STORE HAS LOT OF IPOD TOUCH FOR SALE ,YOU CAN CLICK See other items to find it.
      
      we always ship out item in 24 hours ,with tracking number provided
      ALL USA buyer will take around 10-15 days to receive the item ,
      if item not receive in 30 days pls contact us and we cover all the lost and refund your money
      
      pls contact us before you leaving any negative feedback or open a case
      because we are the tearm always take care on customers, so nothing need to worry about .
      
      thank you for choicing us .!
    PRODUCT_DESCRIPTION
  },
  {
    name: "Apple iPod touch 3rd Generation Black (32 GB) mp3 player With Changer",
    price_cents: 25_20,
    description: <<~PRODUCT_DESCRIPTION
      This Apple iPod touch 3rd Generation mp3 player, in the color black, comes with a USB cable and has a storage capacity of 32 GB. It is a USB MP3 player with a 3.5in screen size and flash-only memory type. The device is a part of the iPod product line and has an excellent battery life.
      
      The iPod touch comes with various features such as video playback, integrated speakers, voice recorder, sleep timer, games, photo viewer, and equalizer controls. It has a headphone jack and USB 2.0 connectivity. The bundle description includes the USB cable and the custom bundle includes the iPod touch itself. The device has a brand name of Apple and is of the 3rd generation. The iPod touch is compatible with MP3 and MP4 playable media formats.
      
      Pictures are part of the description. All items are being sold “AS Found - AS IS".
      
      I strive to describe every item to the best of my ability.
      
      Feel free to ask questions and request additional pictures is needed.
      
      I am not experts in many of the items offered. I make every effort to point out any obvious problems and test it at best of my knowledge. Please keep in mind the age of the item and that there may be some slight flaws from time to time.
      
      No returns will be allowed, so please research the item with the manufacturer to make sure that it will be compatible with your needs.
      
      It will be carefully packed and shipped with a tracking number.
      
      Shipping: I am using this website calculated shipping to mail all my products, if you feel that price can be less, and you can get a better deal, please provide your shipping label and I will accept it. 
    PRODUCT_DESCRIPTION
  },
  {
    name: "Apple iPod touch 3rd Generation Black (32 GB) -",
    price_cents: 19_00,
    description: <<~PRODUCT_DESCRIPTION
      You can never leave home without your favorite music with the Apple iPod touch 3rd generation 32GB model. It was refined and improved from the Apple iPod touch 2nd generation when it was released in September 2009. The 3rd generation iPod touch model has a similar hardware design to the 2nd generation model, but Apple incorporated a number of enhancements. The result can be an awesome music player with podcast support and video playback. It’s faster and has twice the capacity of the 2nd generation model and remains a popular feature packed MP3 player.The 3.5 inch widescreen touch display on the 3rd gen 32GB iPod touch can make it easy to navigate through your stored media. The dimensions are 4.3 by 2.4 by 0.33 inches. In addition to the multitouch interface on the display, Apple has added a few physical buttons. There is a volume control button on the left edge, a hold switch on the top, and a home button on the face of the player. It is Wi-Fi capable, so users can browse the internet anywhere there is a Wi-Fi signal. On this iPod, you can have instant access to a Safari web browser, photo viewer, and an email reader. The ease of accessing video and podcasts simply by touching an icon on the iPod screen can make it a pleasure to use. Most iPod accessory kits offer a black silicone skin case cover protector, USB cable, LCD screen protector, and headphones. With its 32GB storage capacity, the 3rd gen iPod touch holds up to 7,000 songs, 40,000 photos, or 40 hours of video on a full charge. Its long lasting battery can allow for up to 30 hours of non stop audio playback. Users who get their music from multiple sources could have no problem transferring their music to this device. It is compatible with most types of audio files, including MP3, AIFF, WAV, and Apple Lossless. The Shake to Shuffle option allows you to activate the shuffle mode simply by shaking the iPod. Built in Bluetooth capability can make connecting wireless headphones to the iPod a breeze. Playback can be controlled using voice command, a feature that is activated by pressing the headphone remote control. The Genius playlist featured on the 3rd generation iPod touch model includes App Store recommendations based on previous purchases. All you need to do is click on the App Store icon on the main menu and you are on your way. With Genius, you can also find songs in your library that go together and instantly create a playlist. This combines with other features on the portable iPod MP3 player to make it very easy to organize your tracks. This black iPod touch can be the perfect workout partner and can be used while running or exercising at the gym. It can also be a great device to keep you connected while on the go. In a small package, it can give you the ability to browse apps, watch videos and podcasts, check your email, and surf the internet. This generation of iPods is very feature rich and comes with enough storage capacity to hold large media libraries. You can stay entertained wherever you are with this black, 3rd generation iPod.
    PRODUCT_DESCRIPTION
  }
].map do |hash|
  created_at = Faker::Time.backward
  {
    created_at: created_at,
    updated_at: Faker::Time.between(from: created_at, to: Time.now),
    **defaults,
    **hash
  }
end
ipod_touches = Product.insert_all(ipod_touches_hashes)

electronics_id = Category.find_by(name: "Electronics").id
Categorization.insert_all(
  ipod_touches.map do |p|
    {product_id: p["id"], category_id: electronics_id}
  end
)

shirts_hashes = [
  {
    name: "Mariah Carey McDonalds Vintage Signature T-shirt Funny Gift For men Women S-3XL",
    price_cents: 15_85,
    description: <<~PRODUCT_DESCRIPTION
      You've now found the staple t-shirt of your wardrobe. It's made of a thicker, heavier cotton, but it's still soft and comfy. And the double stitching on the neckline and sleeves add more durability to what is sure to be a favorite!
      
      • 100% ring-spun cotton
      • Sport Grey is 90% ring-spun cotton, 10% polyester
      • Dark Heather is 65% polyester, 35% cotton
      • 4.5 oz/y² (153 g/m²)
      • Pre-shrunk
      • Shoulder-to-shoulder taping
      • Quarter-turned to avoid crease down the center
    PRODUCT_DESCRIPTION
  },
  {
    name: "Ripple Junction Xl Pitch Perfect Womens Shirt",
    price_cents: 9_99,
    description: "Ripple Junction Xl Pitch Perfect Womens Shirt."
  }
]
shirts = Product.insert_all(
  shirts_hashes.map do |hash|
    created_at = Faker::Time.backward
    {
      created_at: created_at,
      updated_at: Faker::Time.between(from: created_at, to: Time.now),
      **defaults,
      **hash
    }
  end
)

clothing_id = Category.find_by(name: "Clothing, Shoes & Accessories").id
Categorization.insert_all(
  shirts.map do |p|
    {product_id: p["id"], category_id: clothing_id}
  end
)
