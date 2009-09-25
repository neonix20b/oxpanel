class UserController < ApplicationController
  def index
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    @users = sql.execute("select id,domain,email,disk,mysql,ago from webhosting.view_domains").result;
    @users = [@users[-1]]+@users[0..-2]
    sql.commit_db_transaction;
  end

  def del
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    sql.execute("select webhosting.remove_user(#{params[:id]})");
    sql.commit_db_transaction;
    render :text=> '';  
  end
end
