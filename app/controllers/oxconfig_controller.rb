class OxconfigController < ApplicationController
  def oxconfig
  end

  def index
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    @cfg = sql.execute("select name,value from config.vars").result;
    sql.commit_db_transaction;
  end

  def updatecfg
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    value = params[:value];
    sql.execute("update config.vars set value='"+value+"' where name='"+params[:pole]+"'");
    sql.commit_db_transaction;
    render :text=> value;
  end

  def pkg
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    sql.execute("select webhosting.update_pkg()");
    sql.commit_db_transaction;
    render :text => 'видимо обновилось'
  end
end
