require_relative "poll"
require 'bcrypt'


def create_user(user_first_name, user_email, user_password)
    password_digested = BCrypt::Password.create(user_password)
    sql = "INSERT into users (first_name, email, password_digested) VALUES ($1, $2, $3)RETURNING*;"
    run_sql(sql, [user_first_name, user_email, password_digested])
end

def read_user()
    sql = "SELECT * from users"
    user = run_sql(sql)[0]
    user
end

def read_user_by_id(user_id)
    sql = "SELECT * from users where user_id = $1"
    user = run_sql(sql,[user_id])
    if user.count == 0
        return nil
        else
        return user[0]
    end
end

def read_user_by_email(user_email)
    sql = "SELECT * from users where email = $1"
    user = run_sql(sql,[user_email])
    if user.count == 0
        return nil
        else
        return user[0]
    end
end

def update_user(user_id, first_name, email)
    sql = "UPDATE users SET first_name = $1, email = $2 WHERE user_id = $3"
    run_sql(sql,[first_name, email, user_id])
end

def delete_user_by_id(user_id)
    sql = "Delete from users where user_id = $1"
    user = run_sql(sql,[user_id])
end

def read_email_attempts(request_ip)
    sql = "select email_attempts from email_ip_mapping where request_ip = $1"
    attempts = run_sql(sql,[request_ip])
    if attempts && attempts.count != 0
        return attempts[0]['email_attempts'].to_i
    else
        return 0
    end
end

def create_update_email_attempt(operation, ip, payload, attempts)
    sql = 'insert into email_ip_mapping values ($1, $2, $3)'
    args = [ip, payload.to_s, attempts]
    if(operation == 'update')
        sql = 'update email_ip_mapping set last_payload = $1, email_attempts = $2'
        args = [payload.to_s, attempts]
    end
    sql_response = run_sql(sql,args)
end