class BanksController < ApplicationController
  # GET /banks
  # GET /banks.json
  def index
    @banks = Bank.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @banks }
    end
  end

  # GET /banks/1
  # GET /banks/1.json
  def show
    @bank = Bank.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bank }
    end
  end

  # GET /banks/new
  # GET /banks/new.json
  def new
    @bank = Bank.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bank }
    end
  end

  # GET /banks/1/edit
  def edit
    @bank = Bank.find(params[:id])
  end

  # POST /banks
  # POST /banks.json
  def create
    @bank = Bank.new(params[:bank])

    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice: 'Bank was successfully created.' }
        format.json { render json: @bank, status: :created, location: @bank }
      else
        format.html { render action: "new" }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /banks/1
  # PUT /banks/1.json
  def update
    @bank = Bank.find(params[:id])

    respond_to do |format|
      if @bank.update_attributes(params[:bank])
        format.html { redirect_to @bank, notice: 'Bank was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank = Bank.find(params[:id])
    @bank.destroy

    respond_to do |format|
      format.html { redirect_to banks_url }
      format.json { head :no_content }
    end
  end
end
