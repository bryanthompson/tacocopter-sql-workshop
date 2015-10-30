## Notes 

There are comments in the code where necessary.  

Rather than set up a postgres database locally, I made a simple mysql test db just to get rspec to run happily.  The tests do not touch the database and I didn't have time to use the heroku postgres connection and whack everything between runs, so I just went with mysql to get it done and make it clean.

You should be able to bundle, rake & create the test db, and run rspec to see the tests. 

When you run the rails app, you'll notice that I moved the root action to my own action to present the form.  I did this just to get something clean and isolated to use for the interface.  
