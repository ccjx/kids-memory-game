create a requirements folder, with an index.md for a directory of requirements (R001 onwards numbering) with R001.md providing detailed requirements. The index file has the ID, a short title, and also contains status such as not started, WIP, completed.

add an instructions file such that when i am describing requirements that it should be added to the index.md and the respective detail file e.g. R001.md file. 

the instructions file should also state that when the user is asking for something, it should be clear if it is a requirement or if it is implementation. 
- If it is a requirement, then it should be documented in a related detail file (if not implemented yet) or a new detail file and updated in the index.
- If it is an implementation request, it should include the requirements ID (e.g. R001). At this point, the llm agent should propose an implementation plan, filed under /plans. If any point of the requirement is unclear, the agent should ask clarification questions at this point and refine the implementation plan and requirements as needed. Plans are filed with a P-R001.md filename. There should be an plans-index.md under /plans, which has the plan ID, a short title of the plan, and a status (proposed, rejected, implemented). Only after the user confirms the implementation plan should it be implemented. 

Propose a template for the detailed requirements and plan file in markdown. 

Add the following requirements:
- Main menu with new game, exit and settings
- Settings page is blank for now.
- Exit will quit the game
- New game will go to a game scene
- The main game is a memory game. 
- Memory game displays many tiles (e.g. 12, 16, 24) on the screen. When the user taps or clicks on them, it will flip. if the user flips 2 images that are the same 
Download some placeholder images