const { defineConfig } = require('@vue/cli-service')
const webpack = require('webpack');
module.exports = defineConfig({
  configureWebpack: {
    plugins: [
      new webpack.DefinePlugin({
        'process.env.VITE_DEEPSEEK_API_KEY': JSON.stringify(process.env.VITE_DEEPSEEK_API_KEY),
        'process.env.VUE_APP_AMAP_KEY': JSON.stringify('124ce2b9d9a85f506de67e7b8070d08d'), // Replace with your actual AMap API key
      }),
    ],
  },
  transpileDependencies: true,
  lintOnSave: false,
  // 跨域配置
  devServer: {               //记住，别写错了devServer//设置本地默认端口  选填
    port: 9876,
    proxy: {                  //设置代理，必须填
      '/api': {              //设置拦截器  拦截器格式   斜杠+拦截器名字，名字可以自己定
        target: 'http://localhost:9091',     //代理的目标地址
        changeOrigin: true,              //是否设置同源，输入是的
        pathRewrite: {                   //路径重写
          '^/api': ''                     //恢复路径重写，因为我们已经在Controller和前端请求中都移除了/api前缀
        },
        logLevel: 'debug' // 启用调试日志
      }
    },
    client: {
      overlay: false
    }
  }
})


