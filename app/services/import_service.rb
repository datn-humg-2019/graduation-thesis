class ImportService
  def initialize file, user
    @file = file
    @user = user
  end

  def import
    spreadsheet = open_spreadsheet @file
    header = spreadsheet.row 1
    return if !(header - ProductWarehouse.get_field_ex_im).blank? || spreadsheet.last_row <= 1
    (2..spreadsheet.last_row).each do |i|
      next if spreadsheet.row(i)[2].nil?
      save_update spreadsheet.row(i)
    end
  end

  def save_update row
    product_id = row[1].split("-")[0][1..-1]
    pw = @user.warehouse.product_warehouses.build
    pw.product_id = product_id
    pw.count = row[2].to_i
    pw.price_origin = row[3].to_f
    pw.price_sale = row[4].to_f
    pw.mfg = row[5]
    pw.exp = row[5]
    pw.stop_providing = false
    pw.save_history
    pw.save
  end

  def open_spreadsheet file
    case File.extname file.original_filename
    when ".csv" then Roo::CSV.new file.path
    when ".xls" then Roo::Excel.new file.path
    when ".xlsx" then Roo::Excelx.new file.path
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
