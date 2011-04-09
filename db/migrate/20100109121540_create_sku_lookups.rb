class CreateSkuLookups < ActiveRecord::Migration
  def self.up
    create_table :sku_lookups do |t|
      t.string :sku
      t.string :item_no
      t.timestamps
    end
    SkuLookup.create :sku => "4015918103923", :item_no => "10392"
    SkuLookup.create :sku => "4015918101783", :item_no => "10178"
    SkuLookup.create :sku => "4015918104401", :item_no => "10440"
    SkuLookup.create :sku => "4015918106887", :item_no => "10688"
    SkuLookup.create :sku => "4015918102230", :item_no => "10223"
    SkuLookup.create :sku => "4015918102339", :item_no => "10233"
    SkuLookup.create :sku => "4015918107235", :item_no => "10723"
    SkuLookup.create :sku => "4015918102643", :item_no => "10264"
    SkuLookup.create :sku => "4015918105712", :item_no => "10571"
    SkuLookup.create :sku => "4015918105675", :item_no => "10567"
    SkuLookup.create :sku => "4015918109406", :item_no => "10940"
    SkuLookup.create :sku => "4015918108133", :item_no => "10813"
    SkuLookup.create :sku => "4015918102438", :item_no => "10243"
    SkuLookup.create :sku => "4015918108508", :item_no => "10850"
    SkuLookup.create :sku => "4015918104180", :item_no => "10418"
    SkuLookup.create :sku => "4015918104265", :item_no => "10426"
    SkuLookup.create :sku => "4015918019309", :item_no => "FS01930"
    SkuLookup.create :sku => "4015918102452", :item_no => "10245"
    SkuLookup.create :sku => "4015918102476", :item_no => "10247"
    SkuLookup.create :sku => "4015918102483", :item_no => "10248"
    SkuLookup.create :sku => "4015918108041", :item_no => "10804"
    SkuLookup.create :sku => "4015918104388", :item_no => "10438"
    SkuLookup.create :sku => "4015918105897", :item_no => "10589"
    SkuLookup.create :sku => "4015918105903", :item_no => "10590"
    SkuLookup.create :sku => "4015918105910", :item_no => "10591"
    SkuLookup.create :sku => "4015918103930", :item_no => "10393"
    SkuLookup.create :sku => "4015918102674", :item_no => "10267"
    SkuLookup.create :sku => "4015918022538", :item_no => "FS02253"
    SkuLookup.create :sku => "4015918102506", :item_no => "10250"
    SkuLookup.create :sku => "4015918102513", :item_no => "10251"
    SkuLookup.create :sku => "7640101480733", :item_no => "48073"
    SkuLookup.create :sku => "7640101480627", :item_no => "48062"
    SkuLookup.create :sku => "4015918109192", :item_no => "10919"
    SkuLookup.create :sku => "7640101480559", :item_no => "48055"
    SkuLookup.create :sku => "4015918109895", :item_no => "10989"
    SkuLookup.create :sku => "5060096100126", :item_no => "10012"
    SkuLookup.create :sku => "5060096100133", :item_no => "10013"
    SkuLookup.create :sku => "5060096100140", :item_no => "10014"
    SkuLookup.create :sku => "4015918103503", :item_no => "10350"
    SkuLookup.create :sku => "4015918102834", :item_no => "10283"
    SkuLookup.create :sku => "4015918101752", :item_no => "10175"
    SkuLookup.create :sku => "4015918103893", :item_no => "10389"
    SkuLookup.create :sku => "4015918107099", :item_no => "10709"
    SkuLookup.create :sku => "4015918024037", :item_no => "FS02403"
    SkuLookup.create :sku => "4015918105422", :item_no => "10542"
    SkuLookup.create :sku => "4015918102858", :item_no => "10285"
    SkuLookup.create :sku => "4015918106034", :item_no => "10603"
    SkuLookup.create :sku => "4015918102896", :item_no => "10289"
    SkuLookup.create :sku => "4015918022309", :item_no => "FS02230"
    SkuLookup.create :sku => "4015918105507", :item_no => "10550"
    SkuLookup.create :sku => "4015918100564", :item_no => "10056"
    SkuLookup.create :sku => "4015918102711", :item_no => "10271"
    SkuLookup.create :sku => "4015918023801", :item_no => "FS02380"
    SkuLookup.create :sku => "4015918102759", :item_no => "10275"
    SkuLookup.create :sku => "4015918108720", :item_no => "10872"
    SkuLookup.create :sku => "4015918011112", :item_no => "FS01111"
    SkuLookup.create :sku => "4015918022101", :item_no => "FS02210"
    SkuLookup.create :sku => "4015918109390", :item_no => "10939"
    SkuLookup.create :sku => "7640101480641", :item_no => "48064"
    SkuLookup.create :sku => "7640101480696", :item_no => "48069"
    SkuLookup.create :sku => "7640101480597", :item_no => "48059"
    SkuLookup.create :sku => "4015918111331", :item_no => "11133"
    SkuLookup.create :sku => "4015918102100", :item_no => "10210"
    SkuLookup.create :sku => "4015918110389", :item_no => "11038"
    SkuLookup.create :sku => "4015918106504", :item_no => "10650"
    SkuLookup.create :sku => "9006392000339", :item_no => "FS00033"
    SkuLookup.create :sku => "4015918024068", :item_no => "FS02406"
    SkuLookup.create :sku => "4015918102957", :item_no => "10295"
    SkuLookup.create :sku => "4015918103190", :item_no => "10319"
    SkuLookup.create :sku => "4015918105446", :item_no => "10544"
    SkuLookup.create :sku => "4015918104500", :item_no => "10450"
    SkuLookup.create :sku => "4015918105408", :item_no => "10540"
    SkuLookup.create :sku => "4015918108225", :item_no => "10822"
    SkuLookup.create :sku => "4015918501767", :item_no => "50176"
    SkuLookup.create :sku => "4015918501804", :item_no => "50180"
    SkuLookup.create :sku => "4015918501439", :item_no => "50143"
    SkuLookup.create :sku => "4015918200660", :item_no => "20066"
    SkuLookup.create :sku => "4015918501484", :item_no => "50148"
    SkuLookup.create :sku => "4015918501927", :item_no => "50192"
    SkuLookup.create :sku => "7640101480610", :item_no => "48061"
    SkuLookup.create :sku => "7640101480580", :item_no => "48058"
    SkuLookup.create :sku => "7640101480542", :item_no => "48054"
    SkuLookup.create :sku => "4015918108904", :item_no => "10890"
  end

  def self.down
    drop_table :sku_lookups
  end
end
