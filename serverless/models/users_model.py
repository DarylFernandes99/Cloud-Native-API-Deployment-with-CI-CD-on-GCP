from sqlalchemy import Table, Column, String, MetaData, Boolean, DateTime


class Users:
    def __init__(self) -> None:
        self.meta = MetaData()
        self.users_schema = Table(
            'users', self.meta,
            Column('id', String, primary_key = True, unique = True),
            Column('first_name', String),
            Column('last_name', String),
            Column('password', String),
            Column('username', String),
            Column('is_verified', Boolean),
            Column('verification_token', String),
            Column('mail_sent_time', DateTime),
            Column('account_created', DateTime),
            Column('account_updated', DateTime)
        )
