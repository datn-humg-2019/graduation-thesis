class PdfsController < ApplicationController
  before_action :authenticate_user!

  before_action :get_bill, only: [:bill_pdf]
  before_action :get_sell, only: [:sell_pdf]

  def bill_pdf
    respond_to do |format|
      format.pdf
      format.html{render_sample_html("bill_pdf", @bill)} if Rails.env.development?
    end
  end

  def sell_pdf
    respond_to do |format|
      format.pdf
      format.html{render_sample_html("sell_pdf", @sell)} if Rails.env.development?
    end
  end

  private
  # def create_pw_pdf
  #   PdfService.new @pw
  # end

  # def send_pw_pdf
  #   send_file create_pw_pdf.to_pdf,
  #     filename: "#{Time.current.to_i}.pdf",
  #     type: "application/pdf",
  #     disposition: "inline"
  # end

  def render_sample_html template, datas
    render template: "pdfs/#{template}", layout: "invoice_pdf", locals: {datas: datas}
  end

  def get_bill
    @bill = Bill.find_by id: params[:id]

    return if @bill&.of_user(current_user.id)
    flash[:danger] = t "bill_not_found"
    redirect_to bills_path
  end

  def get_sell
    @sell = Sell.find_by id: params[:id]

    return if @sell&.of_user(current_user.id)
    flash[:danger] = "sell not found"
    redirect_to sells_path
  end
end
