class FixSkuLookups < ActiveRecord::Migration
  def self.up
  	execute "DELETE FROM sku_lookups WHERE sku='4015918200660'"
  	execute "DELETE FROM sku_lookups WHERE sku='5060096100133'"
  	execute "DELETE FROM sku_lookups WHERE sku='5060096100140'"
	execute "UPDATE sku_lookups SET item_no='10227' WHERE sku='4015918101783'"
	execute "UPDATE sku_lookups SET item_no='11040' WHERE sku='7640101480733'"
	execute "UPDATE sku_lookups SET item_no='10157' WHERE sku='7640101480627'"
	execute "UPDATE sku_lookups SET item_no='10711' WHERE sku='7640101480559'"
	execute "UPDATE sku_lookups SET item_no='10158' WHERE sku='7640101480641'"
	execute "UPDATE sku_lookups SET item_no='10421' WHERE sku='7640101480597'"
	execute "UPDATE sku_lookups SET item_no='10921' WHERE sku='7640101480696'"
	execute "UPDATE sku_lookups SET item_no='11130' WHERE sku='9006392000339'"
	execute "UPDATE sku_lookups SET item_no='FS02203' WHERE sku='4015918024068'"
	execute "UPDATE sku_lookups SET item_no='D50135' WHERE sku='7640101480610'"
	execute "UPDATE sku_lookups SET item_no='D50128' WHERE sku='7640101480580'"
	execute "UPDATE sku_lookups SET item_no='D50053' WHERE sku='7640101480542'"
	execute "UPDATE sku_lookups SET item_no='D10984' WHERE sku='4015918501927'"
	SkuLookup.create :sku => '4015918501149', :item_no => 'D50047'
	SkuLookup.create :sku => '4015918011099', :item_no => '01109'
	SkuLookup.create :sku => '4015918012423', :item_no => '50034'
	SkuLookup.create :sku => '4015918102469', :item_no => '10246'
	SkuLookup.create :sku => '401591810597', :item_no => '10597'
	SkuLookup.create :sku => '4015918019040', :item_no => 'FS01904'
	SkuLookup.create :sku => '4015918022521', :item_no => '02252'

  end

  def self.down
  	SkuLookup.create :sku => "4015918200660", :item_no => "20066"
  	SkuLookup.create :sku => "5060096100133", :item_no => "10013"
  	SkuLookup.create :sku => "5060096100140", :item_no => "10014"
	execute "UPDATE sku_lookups SET item_no='10178' WHERE sku='4015918101783'"
	execute "UPDATE sku_lookups SET item_no='48073' WHERE sku='7640101480733'"
	execute "UPDATE sku_lookups SET item_no='48062' WHERE sku='7640101480627'"
	execute "UPDATE sku_lookups SET item_no='48055' WHERE sku='7640101480559'"
	execute "UPDATE sku_lookups SET item_no='10158' WHERE sku='7640101480641'"
	execute "UPDATE sku_lookups SET item_no='48059' WHERE sku='7640101480597'"
	execute "UPDATE sku_lookups SET item_no='48069' WHERE sku='7640101480696'"
	execute "UPDATE sku_lookups SET item_no='FS00033' WHERE sku='9006392000339'"
	execute "UPDATE sku_lookups SET item_no='FS02406' WHERE sku='4015918024068'"
	execute "UPDATE sku_lookups SET item_no='48061' WHERE sku='7640101480610'"
	execute "UPDATE sku_lookups SET item_no='48058' WHERE sku='7640101480580'"
	execute "UPDATE sku_lookups SET item_no='48054' WHERE sku='7640101480542'"
	execute "UPDATE sku_lookups SET item_no='50192' WHERE sku='4015918501927'"
  	execute "DELETE FROM sku_lookups WHERE sku='4015918011099'"
  	execute "DELETE FROM sku_lookups WHERE sku='4015918012423'"
  	execute "DELETE FROM sku_lookups WHERE sku='4015918102469'"
  	execute "DELETE FROM sku_lookups WHERE sku='401591810597'"
  	execute "DELETE FROM sku_lookups WHERE sku='4015918019040'"
  	execute "DELETE FROM sku_lookups WHERE sku='4015918022521'"
  	execute "DELETE FROM sku_lookups WHERE sku='4015918501149'"
	
  end
end
