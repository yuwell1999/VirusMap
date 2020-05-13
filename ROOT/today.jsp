<%@ page session="false" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.BufferedReader,java.io.IOException,java.io.InputStream,java.io.InputStreamReader,java.net.URL,java.net.URLConnection"%>
<%!
		    //只在第一个用户访问时执行
		    String text = null;
		    //时间戳
		    long time = 0;
		%>
    		<%
    		//每一次访问都会执行
    	if(System.currentTimeMillis()-time>600000){
    	    //记录获取数据的时间
    	    time = System.currentTimeMillis();
    		    //1.	创建一个网址对象 url 
    		URL url = new URL("https://zaixianke.com/yq/info?today");
    		//2.	通过网址对象url, 打开连接,并得到连接对象conn
    		URLConnection conn = url.openConnection();
    		//3.	通过连接对象conn , 获取用于读取网页内容的 输入流 is (读取的内容是字节) 
    		InputStream is = conn.getInputStream();
    		//4.	将上述的字节输入流is , 装饰为字符输入流. 
    		//		再将字符输入流,装饰为能一次读取一行的 缓冲输入流 br
    		BufferedReader br = new BufferedReader(new InputStreamReader(is,"UTF-8"));
    		//5.	通过输入流br ,读取一行文字, 并赋值给变量text
    		text = br.readLine();
    	}	
    		%>

    		
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="UTF-8">
<title>疫情地图</title>
<script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/echarts/4.7.0/echarts.min.js"></script> 
<script src="http://cdn.zaixianke.com/china.js"></script>
</head>
<body>
<div id="main" style="width: 100%;height:600px;"></div> <br>
<div style="text-align:center">
	<a style="color:#333" align="center" href="g_index.jsp">查看全球疫情</a>&nbsp;&nbsp;
	<a style="color:#333" align="center" href="index.jsp">查看国内累计确诊</a></div>
<script type="text/javascript">

		
    		
    		var data = <%=text%>;
    		// 第3步: 基于容器，创建一个echarts实例
            var myChart = echarts.init(document.getElementById('main'));
    		var opt = {
                    // 设置标题和副标题及副标题跳转链接
                    title: {
                        text: '新冠疫情-国内新增数据',
                        subtext: '余越出品',
                        sublink: 'https://github.com/yuwell1999'
                    },
                    // 数据提示框
                    tooltip: {
                        trigger: 'item', // item放到数据区域触发
                        formatter:  function (params, ticket, callback) {
                            if(params.data)
                                return params.name+'<br/>'+params.data.value+' (人)';
                            else
                                return params.name+'<br/>无疫情信息';
                        }
                    },

    				// 视觉映射方案:
                    // visualMap默认是连续映射，我们也可以设置为分段型，对于分布范围广的数据
                    // 使用透明度来区分疫情严重情况
                    visualMap: {
                        type: 'piecewise',
                        pieces: [
                            {gt: 50, color: 'darkred'},                        // (1500, Infinity]
                            {gt: 30, lte: 50, color: 'red', colorAlpha: 1},  // (1000, 1500]
                            {gt: 20, lte: 30, color: 'red', colorAlpha: 0.8},
                            {gt: 10, lte: 20, color: 'red', colorAlpha: 0.6},
                            {gt: 5, lte: 10, color: 'red', colorAlpha: 0.4},
                            {gt: 1, lte: 5, color: 'red', colorAlpha: 0.3},
                            {lt: 1, color: 'red', colorAlpha: 0.0}          // (-Infinity, 100)
                        ],
                    },

                    // 具体数据
                    series: [
                        {
                            name: '国内各省确诊病例', // 系列名称
                            zoom:1.2,//地图大小
                            type: 'map', // 系列类型，地图
                            map: 'china', // 要使用的地图，即上面注册的地图名称
                            roam: true, // 开启鼠标缩放和平移漫游
                            label: { // 图形上的文本标签，地图默认显示数据名
                                show: true,
                                formatter: '{b}', // b是数据名，c是数据值
                                fontSize: 8
                            },
                            data: data,
                        }
                    ]
                };
            // 第4步和第5步可以合并，合并myChart.setOption中的内容即可，如下
                myChart.setOption(opt);
   </script>
</body>
</html>