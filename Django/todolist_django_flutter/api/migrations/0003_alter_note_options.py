# Generated by Django 3.2.8 on 2021-11-01 04:50

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_rename_notes_note'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='note',
            options={'ordering': ['-updated']},
        ),
    ]
