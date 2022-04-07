create or replace type logger_oo as object
(
-- Author  : RIM
-- Created : 7-4-2022 12:56
-- Purpose : Wrapper for the standard logger

-- Attributes
  scope        varchar2(1000),
  param_names  wwv_flow_t_varchar2,
  param_values wwv_flow_t_varchar2,

-- Overrule the default constructor
  constructor function logger_oo(scope        in varchar2
                                 ,param_names  in wwv_flow_t_varchar2 default wwv_flow_t_varchar2()
                                 ,param_values in wwv_flow_t_varchar2 default wwv_flow_t_varchar2())
    return self as result,

-- Constructor with only the scope needed
-- use in your procedures decalration section as follows:
--
--   l_log logger_obj := new logger_obj(p_scope => 'yourscope');
--
-- you can now start logging as for example:
--   begin
--     l_log.append_param(p_name => 'paramname', p_value => 'param_value');
--     l_log.append_param(p_name => 'paramdate', p_value => sysdate);
--     l_log.append_param(p_name => 'parambool', p_value => true);
--     l_log.log_start;
--     l_log.log(p_text => 'more logging');
--     l_log.log_end;
--   end;

  constructor function logger_oo(p_scope in varchar2) return self as result,

  member procedure add_param(p_name  in varchar2
                            ,p_value in varchar2),

  member procedure add_param(p_name  in varchar2
                            ,p_value in date),

  member procedure add_param(p_name  in varchar2
                            ,p_value in boolean),

  member procedure log_start,

  member procedure log_end,

  member procedure log_error(p_text        in varchar2
                            ,p_extra       in clob default null
                            ,p_truncparams in boolean default true),

  member procedure log_permanent(p_text        in varchar2
                                ,p_extra       in clob default null
                                ,p_truncparams in boolean default true),

  member procedure log_warning(p_text        in varchar2
                              ,p_extra       in clob default null
                              ,p_truncparams in boolean default true),

  member procedure log_information(p_text        in varchar2
                                  ,p_extra       in clob default null
                                  ,p_truncparams in boolean default true),

  member procedure log(p_text        in varchar2
                      ,p_extra       in clob default null
                      ,p_truncparams in boolean default true),

  member procedure log_userenv(p_detail_level in varchar2 default 'USER' -- ALL, NLS, USER, INSTANCE
                              ,p_show_null    in boolean default false
                              ,p_level        in number default null)
)
/
create or replace type body logger_oo is

  constructor function logger_oo(scope        in varchar2
                                ,param_names  in wwv_flow_t_varchar2
                                ,param_values in wwv_flow_t_varchar2) return self as result is
  begin
    self.scope        := scope;
    self.param_names  := param_names;
    self.param_values := param_values;
    return;
  end logger_oo;

  constructor function logger_oo(p_scope in varchar2) return self as result is
  begin
    self := new logger_oo(scope        => p_scope
                         ,param_names  => wwv_flow_t_varchar2()
                         ,param_values => wwv_flow_t_varchar2());
    return;
  end logger_oo;

  member procedure add_param(p_name  in varchar2
                            ,p_value in varchar2) is
  begin
    self.param_names.extend(1);
    self.param_values.extend(1);
    self.param_names(self.param_names.count) := p_name;
    self.param_values(self.param_values.count) := p_value;
  end add_param;

  member procedure add_param(p_name  in varchar2
                            ,p_value in date) is
  begin
    self.add_param(p_name  => p_name
                  ,p_value => to_char(p_value, apex_json.c_date_iso8601));
  end add_param;

  member procedure add_param(p_name  in varchar2
                            ,p_value in boolean) is
  begin
    self.add_param(p_name  => p_name
                  ,p_value => case
                                when p_value = true then
                                 '{TRUE}'
                                else
                                 '{FALSE}'
                              end);
  end add_param;

  member procedure log_start is
  begin
  
    self.log(p_text => 'Start', p_extra => null, p_truncparams => true);
  
  end log_start;

  member procedure log_end is
  begin
  
    self.log(p_text => 'End', p_extra => null, p_truncparams => true);
  
  end log_end;

  member procedure log_error(p_text        in varchar2
                            ,p_extra       in clob default null
                            ,p_truncparams in boolean default true) is
    t_logparams logger.tab_param;
  begin
  
    for ii in 1 .. self.param_names.count
    loop
      logger.append_param(p_params => t_logparams
                         ,p_name   => self.param_names(ii)
                         ,p_val    => self.param_values(ii));
    end loop;
  
    if p_truncparams
    then
      self.param_names.delete();
      self.param_values.delete();
    end if;
  
    logger.log_error(p_text   => p_text
                    ,p_scope  => self.scope
                    ,p_extra  => p_extra
                    ,p_params => t_logparams);
  
  end log_error;

  member procedure log_permanent(p_text        in varchar2
                                ,p_extra       in clob default null
                                ,p_truncparams in boolean default true) is
    t_logparams logger.tab_param;
  begin
  
    for ii in 1 .. self.param_names.count
    loop
      logger.append_param(p_params => t_logparams
                         ,p_name   => self.param_names(ii)
                         ,p_val    => self.param_values(ii));
    end loop;
  
    if p_truncparams
    then
      self.param_names.delete();
      self.param_values.delete();
    end if;
  
    logger.log_permanent(p_text   => p_text
                        ,p_scope  => self.scope
                        ,p_extra  => p_extra
                        ,p_params => t_logparams);
  
  end log_permanent;

  member procedure log_warning(p_text        in varchar2
                              ,p_extra       in clob default null
                              ,p_truncparams in boolean default true) is
    t_logparams logger.tab_param;
  begin
  
    for ii in 1 .. self.param_names.count
    loop
      logger.append_param(p_params => t_logparams
                         ,p_name   => self.param_names(ii)
                         ,p_val    => self.param_values(ii));
    end loop;
  
    if p_truncparams
    then
      self.param_names.delete();
      self.param_values.delete();
    end if;
  
    logger.log_warning(p_text   => p_text
                      ,p_scope  => self.scope
                      ,p_extra  => p_extra
                      ,p_params => t_logparams);
  
  end log_warning;

  member procedure log_information(p_text        in varchar2
                                  ,p_extra       in clob default null
                                  ,p_truncparams in boolean default true) is
    t_logparams logger.tab_param;
  begin
  
    for ii in 1 .. self.param_names.count
    loop
      logger.append_param(p_params => t_logparams
                         ,p_name   => self.param_names(ii)
                         ,p_val    => self.param_values(ii));
    end loop;
  
    if p_truncparams
    then
      self.param_names.delete();
      self.param_values.delete();
    end if;
  
    logger.log_info(p_text   => p_text
                   ,p_scope  => self.scope
                   ,p_extra  => p_extra
                   ,p_params => t_logparams);
  
  end log_information;

  member procedure log(p_text        in varchar2
                      ,p_extra       in clob default null
                      ,p_truncparams in boolean default true) is
    t_logparams logger.tab_param;
  begin
  
    for ii in 1 .. self.param_names.count
    loop
      logger.append_param(p_params => t_logparams
                         ,p_name   => self.param_names(ii)
                         ,p_val    => self.param_values(ii));
    end loop;
  
    if p_truncparams
    then
      self.param_names.delete();
      self.param_values.delete();
    end if;
  
    logger.log(p_text   => p_text
              ,p_scope  => self.scope
              ,p_extra  => p_extra
              ,p_params => t_logparams);
  
  end log;

  member procedure log_userenv(p_detail_level in varchar2 default 'USER' -- ALL, NLS, USER, INSTANCE
                              ,p_show_null    in boolean default false
                              ,p_level        in number default null) is
  begin
  
    logger.log_userenv(p_detail_level => p_detail_level
                      ,p_show_null    => p_show_null
                      ,p_scope        => self.scope
                      ,p_level        => p_level);
  end log_userenv;

end;
/
