class OxdnsController < ApplicationController
  protect_from_forgery :except => [:change_dns]
  
  def oxdns
  end

  def index
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    #@zones = sql.execute("select distinct zone from dns.dns_records").result;
    @soa = sql.execute("select id,"+soaarr.join(',')+",zone from dns.dns_records where type = 'SOA'").result;
    sql.commit_db_transaction;
    #render :text => @zones.first[0];
  end
  
  def viewzone
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    @soa = sql.execute("select id,"+soaarr.join(',')+" from dns.dns_records where type = 'SOA' and zone = '"+params[:zone]+"'").result;
    @NS = sql.execute("select id,"+nsarr.join(',')+" from dns.dns_records where type = 'NS' and zone = '"+params[:zone]+"'").result;
    @MX = sql.execute("select id,"+mxarr.join(',')+" from dns.dns_records where type = 'MX' and zone = '"+params[:zone]+"'").result;
    @A = sql.execute("select id,"+aarr.join(',')+" from dns.dns_records where type = 'A' and zone = '"+params[:zone]+"'").result;
    @CNAME = sql.execute("select id,"+cnamearr.join(',')+" from dns.dns_records where type = 'CNAME' and zone = '"+params[:zone]+"'").result;
    sql.commit_db_transaction;
    #render :text => "<table><tr><td>"+@CNAME.first.join('</td><td>')+"</td></tr></table>";
  end
  
  def change_dns
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    #params[:id] - id записи которой менять, params[:pole] - поле, например ttl; params[:value] - новое значение этого поля sql.execute("select id,host,ttl,data from dns.dns_records where type = 'NS' and zone = '"+params[:zone]+"'").result;
    if params[:value] !~ /^\d+$/
      value = "'"+params[:value]+ "'";
    else
      value = params[:value];
    end
    sql.execute("update dns.dns_records set "+params[:pole]+"="+value+" where id="+params[:id]);
    #sql.execute("update  dns.dns_records set serial=nextval('dns.serial_number') where zone='"+params[:zone]+"' and type='SOA'");
    sql.commit_db_transaction;
    render :text=> params[:value];
  end
  
  def del
    sql = ActiveRecord::Base.connection();
    sql.execute "SET autocommit=1";
    sql.begin_db_transaction;
    sql.execute("delete from dns.dns_records where id="+params[:id]);
    sql.commit_db_transaction;
    render :text=> '';    
  end

  def reconn
    #@connection.reconnect!
    ActiveRecord::Base.connection.reconnect!
    redirect_to :protocol => "https://", :action => 'index';
  end
  
  def add
    
    if params[:frm]
      sql = ActiveRecord::Base.connection();
      sql.execute "SET autocommit=1";
      sql.begin_db_transaction;
      if params[:frm][:tps] == 'SOA'
        sql.execute("insert into dns.dns_records(zone,host,ttl,type,data,resp_person,refresh,retry,expire,minimum) values('"+params[:frm][:zone]+"','"+params[:frm][:host]+"',"+params[:frm][:ttl]+",'SOA','"+params[:frm][:data]+"','"+params[:frm][:resp_person]+"',"+params[:frm][:refresh]+","+params[:frm][:retry]+","+params[:frm][:expire]+","+params[:frm][:minimum]+")");
      end
      if params[:frm][:tps] == 'MX'
        sql.execute("insert into dns.dns_records(zone,host,ttl,type,mx_priority,data) values('"+params[:frm][:zone]+"','"+params[:frm][:host]+"',"+params[:frm][:ttl]+",'MX',"+params[:frm][:mx_priority]+",'"+params[:frm][:data]+"')");
      end
      if params[:frm][:tps] == 'A'
        sql.execute("insert into dns.dns_records(zone,host,ttl,type,data) values('"+params[:frm][:zone]+"','"+params[:frm][:host]+"',"+params[:frm][:ttl]+",'A','"+params[:frm][:data]+"')");
      end
      if params[:frm][:tps] == 'CNAME'
        sql.execute("insert into dns.dns_records(zone,host,ttl,type,data) values('"+params[:frm][:zone]+"','"+params[:frm][:host]+"',"+params[:frm][:ttl]+",'CNAME','"+params[:frm][:data]+"')");
      end
      if params[:frm][:tps] == 'NS'
        sql.execute("insert into dns.dns_records(zone,host,ttl,type,data) values('"+params[:frm][:zone]+"','"+params[:frm][:host]+"',"+params[:frm][:ttl]+",'NS','"+params[:frm][:data]+"')");
      end
      sql.commit_db_transaction;
      redirect_to :protocol => "https://", :action => 'index';
    else
      render :text => params.join('<br/>')
    end
  end
end
