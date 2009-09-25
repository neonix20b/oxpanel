class OxmailController < ApplicationController
  protect_from_forgery :except => [:change_password]

  def oxmail
  end

  def index
    sql = ActiveRecord::Base.connection();
    sql.begin_db_transaction;
    @users = sql.execute("SELECT * from mail.view_users").result;
    sql.commit_db_transaction;
    #render :text => arr[1][0];
  end
  
  def viewalias
    @aliases = Array.new();
    sql = ActiveRecord::Base.connection();
    sql.begin_db_transaction;
    @aliase = sql.execute("SELECT * from mail.view_aliases").result;
    sql.commit_db_transaction;
    @aliase.each do |p|
      @aliases[@aliases.size] = p if p[0]== params[:mail];
    end
  end
  
  def ctrluser
    sql = ActiveRecord::Base.connection();
    sql.begin_db_transaction;
    if params[:do]=='reg'
      sql.execute("SELECT mail.register_user('"+params[:frm][:user]+"', '"+params[:frm][:pass]+"')");
      redirect_to :protocol => "https://", :action => 'index';
    else
      sql.execute("SELECT mail.unregister_user('"+params[:user]+"')");
      render :text=>'';
    end
    sql.commit_db_transaction;
    
  end
  
  def change_password
    sql = ActiveRecord::Base.connection();
    sql.begin_db_transaction
    sql.execute("SELECT mail.change_password('"+params[:user]+"', '"+params[:value]+"')");
    sql.commit_db_transaction
    render :text => params[:value];
  end
  
  def ctrlalias
    sql = ActiveRecord::Base.connection();
    sql.begin_db_transaction;
    if params[:do]=='reg'
      sql.execute("SELECT mail.register_alias('"+params[:frm][:user]+"', '"+params[:frm][:alias]+"')");
      redirect_to :protocol => "https://", :action => 'index';
    else
      sql.execute("SELECT mail.unregister_alias('"+params[:user]+"', '"+params[:alias]+"')");
      render :text=>'';
    end
    sql.commit_db_transaction;
  end
end
