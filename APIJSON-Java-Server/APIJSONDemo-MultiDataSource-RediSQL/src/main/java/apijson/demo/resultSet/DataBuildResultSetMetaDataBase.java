package apijson.demo.resultSet;

import com.alibaba.druid.util.jdbc.ResultSetMetaDataBase;

import java.util.List;

public class DataBuildResultSetMetaDataBase extends ResultSetMetaDataBase {

    public DataBuildResultSetMetaDataBase(List<String> headers) {
        ColumnMetaData columnMetaData;
        for (String column : headers) {
            columnMetaData = new ColumnMetaData();
            columnMetaData.setColumnLabel(column);
            columnMetaData.setColumnName(column);
            getColumns().add(columnMetaData);
        }
    }

}
