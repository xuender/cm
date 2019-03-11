var path = require('path');
module.exports = {
  entry: './src/background.ts',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: [
          {
            loader: 'ts-loader',
            options: {
              // transpileOnly: true,
              configFile: path.resolve(__dirname, 'src/tsconfig.background.json')
            }
          }
        ],
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.js']
  },
  devtool: 'cheap-module-source-map',
  output: {
    filename: 'background.js',
    path: path.resolve(__dirname, 'dist')
  }
};
