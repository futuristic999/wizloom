class WeightEntriesController < ApplicationController
  # GET /weight_entries
  # GET /weight_entries.json
  def index
    @weight_entries = WeightEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @weight_entries }
    end
  end

  # GET /weight_entries/1
  # GET /weight_entries/1.json
  def show
    @weight_entry = WeightEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @weight_entry }
    end
  end

  # GET /weight_entries/new
  # GET /weight_entries/new.json
  def new
    @weight_entry = WeightEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @weight_entry }
    end
  end

  # GET /weight_entries/1/edit
  def edit
    @weight_entry = WeightEntry.find(params[:id])
  end

  # POST /weight_entries
  # POST /weight_entries.json
  def create
    @weight_entry = WeightEntry.new(params[:weight_entry])

    respond_to do |format|
      if @weight_entry.save
        format.html { redirect_to @weight_entry, notice: 'Weight entry was successfully created.' }
        format.json { render json: @weight_entry, status: :created, location: @weight_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @weight_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /weight_entries/1
  # PUT /weight_entries/1.json
  def update
    @weight_entry = WeightEntry.find(params[:id])

    respond_to do |format|
      if @weight_entry.update_attributes(params[:weight_entry])
        format.html { redirect_to @weight_entry, notice: 'Weight entry was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @weight_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weight_entries/1
  # DELETE /weight_entries/1.json
  def destroy
    @weight_entry = WeightEntry.find(params[:id])
    @weight_entry.destroy

    respond_to do |format|
      format.html { redirect_to weight_entries_url }
      format.json { head :ok }
    end
  end
end
