package ticket10;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class DorisDataGenerator {
    // Doris连接配置（需替换为实际环境信息）
    private static final String JDBC_URL = "jdbc:mysql://cdh01:9030/test_yi?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    // 基础数据配置（匹配文档中页面类型和业务场景）
    private static final List<String> STORES;
    static {
        List<String> list = new ArrayList<>();
        for (int i = 1; i <= 50; i++) {
            list.add(String.format("store_%03d", i)); // 格式化生成3位数字的店铺ID
        }
        STORES = Collections.unmodifiableList(list);
    }    private static final List<String> WIRELESS_PAGE_TYPES = Arrays.asList("首页", "活动页", "分类页", "商品详情页", "新品页");
    private static final List<String> PAGE_CATEGORIES = Arrays.asList("店铺页", "商品详情页", "店铺其他页");
    private static final Map<String, List<String>> PAGE_SUBTYPES = new HashMap<String, List<String>>() {{
        put("店铺页", Arrays.asList("首页", "活动页", "分类页", "宝贝页", "新品页"));
        put("商品详情页", Arrays.asList("基础详情页", "规格选择页"));
        put("店铺其他页", Arrays.asList("订阅页", "直播页", "客服页"));
    }};
    private static final List<String> PC_SOURCE_PAGES = Arrays.asList("搜索引擎", "外部链接", "站内首页", "分类列表页", "活动专题页");

    public static void main(String[] args) {
        // 用多线程并行执行，充分利用 CPU 资源
        ExecutorService executor = Executors.newFixedThreadPool(4); // 4张表，开4线程

        // 提交任务
        executor.submit(() -> writeOdsWirelessInstoreLog(1000000));
        executor.submit(() -> writeOdsPageVisitLog(1200000));
        executor.submit(() -> writeOdsInstoreFlowLog(1500000));
        executor.submit(() -> writeOdsPcEntryLog(800000));

        // 关闭线程池
        executor.shutdown();
        try {
            if (!executor.awaitTermination(1, TimeUnit.HOURS)) {
                executor.shutdownNow();
            }
            System.out.println("所有表数据生成完成！");
        } catch (InterruptedException e) {
            executor.shutdownNow();
        }
    }

    /**
     * 写入无线端入店日志表（对应文档中“无线入店与承接”需求）
     */
    private static void writeOdsWirelessInstoreLog(int total) {
        String sql = "INSERT INTO ods_wireless_instore_log " +
                "(visitor_id, store_id, page_type, visit_time, is_buy, dt) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        batchInsert(sql, total, "ods_wireless_instore_log", new InsertHandler() {
            @Override
            public void setParams(PreparedStatement pstmt, Random random, Date visitTime) throws SQLException {
                pstmt.setString(1, "visitor_" + random.nextInt(500000)); // 访客ID
                pstmt.setString(2, STORES.get(random.nextInt(STORES.size()))); // 店铺ID
                pstmt.setString(3, WIRELESS_PAGE_TYPES.get(random.nextInt(WIRELESS_PAGE_TYPES.size()))); // 入店页面类型
                pstmt.setString(4, TIME_FORMAT.format(visitTime)); // 入店时间
                pstmt.setInt(5, random.nextDouble() < 0.2 ? 1 : 0); // 是否下单（20%转化率）
                pstmt.setString(6, DATE_FORMAT.format(visitTime)); // 日期分区
            }
        });
    }

    /**
     * 写入页面访问明细日志表（对应文档中“页面访问排行”需求）
     */
    private static void writeOdsPageVisitLog(int total) {
        String sql = "INSERT INTO ods_page_visit_log " +
                "(visitor_id, store_id, page_category, page_subtype, visit_time, leave_time, stay_time, dt) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        batchInsert(sql, total, "ods_page_visit_log", (pstmt, random, visitTime) -> {
            String pageCategory = PAGE_CATEGORIES.get(random.nextInt(PAGE_CATEGORIES.size()));
            int staySeconds = random.nextInt(2) ; // 停留2秒
            Date leaveTime = new Date(visitTime.getTime() + TimeUnit.SECONDS.toMillis(staySeconds));

            pstmt.setString(1, "visitor_" + random.nextInt(500000));
            pstmt.setString(2, STORES.get(random.nextInt(STORES.size())));
            pstmt.setString(3, pageCategory); // 页面大类
            pstmt.setString(4, PAGE_SUBTYPES.get(pageCategory).get(random.nextInt(PAGE_SUBTYPES.get(pageCategory).size()))); // 细分类型
            pstmt.setString(5, TIME_FORMAT.format(visitTime)); // 访问开始时间
            pstmt.setString(6, TIME_FORMAT.format(leaveTime)); // 访问结束时间
            pstmt.setInt(7, staySeconds); // 停留时长
            pstmt.setString(8, DATE_FORMAT.format(visitTime));
        });
    }

    /**
     * 写入店内流转路径日志表（对应文档中“店内流转路径”需求）
     */
    private static void writeOdsInstoreFlowLog(int total) {
        List<String[]> jumpRelations = Arrays.asList( // 合理跳转关系，匹配文档中流转场景
                new String[]{"首页", "活动页"},
                new String[]{"分类页", "商品详情页"},
                new String[]{"活动页", "商品详情页"},
                new String[]{"商品详情页", "宝贝页"}
        );
        String sql = "INSERT INTO ods_instore_flow_log " +
                "(visitor_id, store_id, source_page, target_page, jump_time, dt) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        batchInsert(sql, total, "ods_instore_flow_log", (pstmt, random, jumpTime) -> {
            String[] jump = jumpRelations.get(random.nextInt(jumpRelations.size()));
            pstmt.setString(1, "visitor_" + random.nextInt(500000));
            pstmt.setString(2, STORES.get(random.nextInt(STORES.size())));
            pstmt.setString(3, jump[0]); // 来源页面
            pstmt.setString(4, jump[1]); // 去向页面
            pstmt.setString(5, TIME_FORMAT.format(jumpTime)); // 跳转时间
            pstmt.setString(6, DATE_FORMAT.format(jumpTime));
        });
    }

    /**
     * 写入PC端流量入口日志表（对应文档中“PC端数据”需求）
     */
    private static void writeOdsPcEntryLog(int total) {
        String sql = "INSERT INTO ods_pc_entry_log " +
                "(visitor_id, store_id, source_page, visit_time, dt) " +
                "VALUES (?, ?, ?, ?, ?)";
        batchInsert(sql, total, "ods_pc_entry_log", (pstmt, random, visitTime) -> {
            pstmt.setString(1, "visitor_" + random.nextInt(500000));
            pstmt.setString(2, STORES.get(random.nextInt(STORES.size())));
            pstmt.setString(3, PC_SOURCE_PAGES.get(random.nextInt(PC_SOURCE_PAGES.size()))); // PC端来源
            pstmt.setString(4, TIME_FORMAT.format(visitTime));
            pstmt.setString(5, DATE_FORMAT.format(visitTime));
        });
    }

    /**
     * 批量插入通用方法（优化大数据量写入效率）
     */
    @FunctionalInterface
    private interface InsertHandler {
        void setParams(PreparedStatement pstmt, Random random, Date time) throws SQLException;
    }

    private static void batchInsert(String sql, int total, String tableName, InsertHandler handler) {
        try (Connection conn = DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false); // 关闭自动提交，批量提交
            Random random = new Random();
            int batchSize = 10000; // 每批次10000条，减少交互
            int count = 0;

            // 生成2025-07月的随机时间（匹配文档中分区p202507）
            long startTime = new GregorianCalendar(2025, Calendar.JULY, 1).getTimeInMillis();
            long endTime = new GregorianCalendar(2025, Calendar.JULY, 31).getTimeInMillis();

            for (int i = 0; i < total; i++) {
                long randomTime = startTime + (long) (random.nextDouble() * (endTime - startTime));
                Date time = new Date(randomTime);

                handler.setParams(pstmt, random, time);
                pstmt.addBatch();
                count++;

                // 每1万条数据通知一次
                if (count % 10000 == 0) {
                    System.out.println(tableName + " 已写入：" + count + "条");
                }

                if (count % batchSize == 0) {
                    pstmt.executeBatch();
                    conn.commit();
                }
            }

            // 提交剩余数据
            pstmt.executeBatch();
            conn.commit();
            System.out.println(tableName + " 写入完成，总条数：" + total);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}