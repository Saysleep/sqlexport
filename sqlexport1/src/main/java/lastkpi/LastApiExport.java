package lastkpi;

import java.io.*;
import java.time.LocalDate;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.nio.file.*;

import com.alibaba.druid.pool.DruidDataSource;

import com.alibaba.druid.pool.DruidPooledConnection;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import utils.DruidUtils;

public class LastApiExport {
    public void getDefendants(String name,String sqlFile) throws Exception {
        // 定义今天的日期
        LocalDate date = LocalDate.now();
        String today = date.toString();
        // define new workbook to create new excel
        //@SuppressWarnings("unused")
        //Workbook readWorkbook = WorkbookFactory.create(new FileInputStream("D:/sqlexport/sqlexport1/export/" + name + today + ".xls"));
        @SuppressWarnings("resource")
        Workbook writeWorkbook = new HSSFWorkbook();
        Sheet desSheet = writeWorkbook.createSheet("new sheet");
        Statement stmt = null;
        ResultSet rs = null;
        /*获取数据源以及将查询结果写入excel*/
        try {
            //获取sql
            String query = new String(Files.readAllBytes(Paths.get("D:\\sqlexport\\sqlexport1\\source\\" + sqlFile)));
            System.out.println(query);
            //获取mysql数据连接并查询
            DruidDataSource conn = DruidUtils.getDruidSource("10.0.0.15", 3306, "root", "123456");
            DruidPooledConnection con = conn.getConnection();
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            ResultSetMetaData rsmd = rs.getMetaData();
            //统计数据行号并逐行插入指定excel中
            int columnsNumber = rsmd.getColumnCount();
            Row desRow1 = desSheet.createRow(0);
            for (int col = 0; col < columnsNumber; col++) {
                Cell newpath = desRow1.createCell(col);
                newpath.setCellValue(rsmd.getColumnLabel(col + 1));
            }
            while (rs.next()) {
                System.out.println("Row number" + rs.getRow());
                Row desRow = desSheet.createRow(rs.getRow());
                for (int col = 0; col < columnsNumber; col++) {
                    Cell newpath = desRow.createCell(col);
                    newpath.setCellValue(rs.getString(col + 1));
                }
                FileOutputStream fileOut = new FileOutputStream("D:/sqlexport/sqlexport1/export/" + name + today +"汇总.xls");
                writeWorkbook.write(fileOut);
                fileOut.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            //异常处理
            System.out.println("Failed to get data from database");
        }
    }


    public static void main(String[] args) throws IOException {
        LastApiExport export = new LastApiExport();
        try {
            //export.getDefendants("完成率明细","order_completion_details_perday.sql");
            //export.getDefendants("采购完成明细","purchase_details_perday.sql");
            //export.getDefendants("接单明细","receive_order.sql");
            //export.getDefendants("销售明细","sale_order.sql");
            //export.getDefendants("销售明细","sale_order.sql");
            //export.getDefendants("生产明细","production_order.sql");
            //export.getDefendants("销售订单成品库存明细","sale_storage.sql"); --low effect
            //export.getDefendants("本周生产计划率明细","plan_finish_production.sql");
            //export.getDefendants("本周采购计划率明细","plan_finish_purchase.sql");

            //export.getDefendants("上周完成率","last_week_finished_rate.sql");
            //export.getDefendants("上周业绩","last_week_finished_quantities.sql");
            //export.getDefendants("本周计划单数","this_week_plan_finished_quantities.sql");
            //export.getDefendants("本周计划台数","this_week_plan_finished_order_quantities.sql");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
