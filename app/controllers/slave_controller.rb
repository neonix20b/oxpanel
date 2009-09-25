class SlaveController < ApplicationController
  def slave
  end

  def index
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    @slaves = sql.execute("select slave from dns.slaves").result;
    sql.commit_db_transaction;
  end
  
  def refresh
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    if params[:slave]!='all'
      sql.execute("select dns.create_slave('"+params[:slave]+"')");
    else
      sql.execute("select dns.sync_slaves()");
    end
    sql.commit_db_transaction;
    params[:slave]='Обновили все' if params[:slave]=='all';
    render :text => params[:slave]
  end
  
  def del
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    sql.execute("delete from dns.slaves where slave='"+params[:slave]+"'");
    sql.commit_db_transaction;
    render :text=> '';  
  end
  
  def add
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    sql.execute("select dns.create_slave('"+params[:frm][:slave]+"')");
    sql.commit_db_transaction;
    render :text => params[:frm][:slave]
  end
end
