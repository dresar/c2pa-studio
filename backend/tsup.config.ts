import type { Options } from 'tsup';

const config: Options = {
  entry: {
    app: 'src/server.ts',
  },
  outDir: '.',
  format: ['cjs'],
  platform: 'node',
  target: 'node18',
  bundle: true,
  minify: false,
  sourcemap: false,
  clean: false,
  outExtension: () => ({ js: '.js' }),
  noExternal: [/.*/],
  esbuildOptions(options) {
    options.outbase = 'src';
  },
};

export default config;
