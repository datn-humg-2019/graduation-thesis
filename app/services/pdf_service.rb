class PdfService
  def initialize datas, template
    @datas = datas
    @template = template
  end

  def to_pdf
    PDFKit.new(as_html, page_size: "A4")
    # kit.to_file("#{Rails.root}/public/invoice.pdf")
  end

  def filename
    "#{Time.current.to_i}.pdf"
  end

  private
  def as_html
    render template: "pdfs/#{@template}", layout: "invoice_pdf", locals: {datas: datas}
  end
end
