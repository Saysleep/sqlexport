package utils;

import com.alibaba.druid.pool.DruidDataSource;

public class DruidUtils {
    public static DruidDataSource getDruidSource(String hostname,int port,String username,String password) {
        //1、创建数据源（数据库连接池）对象
        DruidDataSource ds = new DruidDataSource();

        //2、设置参数
        //(1)设置基本参数
        ds.setDriverClassName("com.mysql.jdbc.Driver");
        ds.setUrl("jdbc:mysql://" + hostname + ":" + port + "/jie_mdm");
        ds.setUsername(username);
        ds.setPassword(password);


        //(2)设置连接数等参数
        ds.setMaxActive(10);//最多不超过10个，如果10都用完了，还没还回来，就会出现等待
        ds.setMaxWait(1000000000);//用户最多等1000毫秒，如果1000毫秒还没有人还回来，就异常了

        //3、 返回对象
        return ds;
    }
}
