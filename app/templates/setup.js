var shell = require('shelljs');

if (!shell.test('-f', 'styleguide/package.json')) {
  shell.echo('******************************************************');
  shell.echo('Styleguide not initialized');
  shell.echo('Run the following command to initialize the styleguide:\n');

  shell.echo(
    'cd styleguide && npm init -y && npx -p @storybook/cli sb init --type react\n',
  );
  shell.echo('******************************************************');
} else {
  shell.echo('Everything is configured!');
}
