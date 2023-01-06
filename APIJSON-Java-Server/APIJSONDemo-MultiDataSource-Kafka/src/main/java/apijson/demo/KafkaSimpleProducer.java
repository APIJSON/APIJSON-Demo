package apijson.demo;

import java.util.Properties;
import java.util.concurrent.Future;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class KafkaSimpleProducer {

	public static int sendMessage(String datasource, Properties props,String topic, Object message) {
		KafkaProducer<String, Object> producer = null;
		try {
			/* 9.创建生产者对象 */
			producer = new KafkaProducer<>(props);
			Future<RecordMetadata> future = producer.send(new ProducerRecord<>(topic, message));
			RecordMetadata rMetadata = future.get(); // 调用future的get方法，让main线程阻塞，就可以实现同步发送 
			log.info("rMetadata: {}", rMetadata.toString());
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalArgumentException("动态数据源配置错误 " + datasource);
		} finally {
			if(producer != null) {
				/* 关闭资源 */  
				producer.close();
			}
		}
	}
}
