# ============================================================
#  SEPARATION OF CONCERNS (SoC) — Sabse Aasan Hinglish Guide
# ============================================================
#
#  Kabhi aisi class dekhi hai jo DB se data laaye, UI ke liye
#  format kare, result log kare, aur notification bhi bhej de?
#  Ya ek function jo validation, business logic, database access,
#  aur error handling sab ek jagah kare?
#
#  Agar haan, toh tumne Separation of Concerns (SoC) tod diya.
#  Chalo isko aasan bhasha mein samajhte hain.
#
# ============================================================
#
#  1. SoC kya hai? (Simple mein)
#  ------------------------------
#  "Separation of Concerns" ka matlab hai system ko aise organize
#  karna ki har hissa ek distinct "concern" (zimmedari) sambhaale.
#  Har part ek kaam kare, aur woh achi tarah kare.
#
#  Simple Analogy — Restaurant:
#  Ek restaurant mein 3 hisse hote hain:
#  1. Front of House (Waiters): Order lete hain, khana serve karte
#     hain. Customer se baat karte hain. Pakwaan nahi banate.
#  2. Kitchen (Chefs): Order ticket lete hain, khana banate hain.
#     Customer se baat nahi karte.
#  3. Supply Chain: Sabzi aur samaan laate hain. Pakwaan nahi
#     banate, serve nahi karte.
#
#  Teeno apni zimmedari alag karte hain, aur ek doosre se
#  well-defined boundaries (order tickets, requests) ke through
#  baat karte hain. Agar supply chain ka tomato laane ka tareeka
#  badal gaya, toh waiter ka kaam nahi badlega. Waiter ka greeting
#  badal gaya, toh chef ki recipe nahi badlegi.
#
#  Software mein bhi yahi hona chahiye:
#  - Presentation Layer (Front of House): User se interact karo,
#    input lo, output do.
#  - Business Logic (Kitchen): Core rules aur processes. Yahan
#    asli kaam hota hai.
#  - Data Access (Supply Chain): DB ya API se data laana/lejana.
#  Har layer apna kaam kare, dusre ki internal details na jaane.
#
# ============================================================
#
#  2. Problem: Ek class sab kuch kar rahi hai (God Class)
#  -------------------------------------------------------
#  Maan lo blog platform bana rahe ho. PostManager class ka
#  create_post method sab kuch kar raha hai:
#
#  class PostManager:
#      def create_post(self, request, response):
#          # Concern 1: HTTP parsing
#          title = request.get_parameter("title")
#          # Concern 2: Validation
#          if title is None: response.set_status(400); return
#          # Concern 3: Business logic
#          post = Post(title, content)
#          # Concern 4: Persistence (DB)
#          Database.save(post)
#          # Concern 5: Logging
#          Logger.log("Post created: " + title)
#          # Concern 6: HTTP response
#          response.set_status(200)
#
#  Dekho yeh method. HTTP parsing, validation, business logic, DB
#  save, logging, aur HTTP response — 6 alag-alag kaam ek hi jagah.
#  Isko "God Class" ya "God Method" bolte hain jo sab handle kare.
#
#  Isme 4 problems hain:
#  1. Padhna mushkil (Harder to Read): Naya developer padhega toh
#     HTTP, validation, DB, logging sab ek saath samajhna padega.
#     Bahut mental effort lagega.
#  2. Maintain karna mushkil (Difficult to Maintain): Ek concern
#     change karo, toh dusre risk mein aa jaate hain. DB change
#     karoge, toh HTTP response kharab ho sakta hai galti se.
#  3. Test karna mushkil (Poor Testability): Business logic test
#     karne ke liye HTTP request, response, DB, logger sab mock
#     karne padenge. Isolation mein test nahi kar sakte.
#  4. Code Duplication: Dusre endpoint ko bhi title validation
#     chahiye hoga, toh copy paste karna padega. Naya rule add
#     hua, toh sab jagah update karna padega.
#
# ============================================================
#
#  3. Solution: Refactoring (Layers mein todhna)
#  ---------------------------------------------
#  Strategy: In concerns ko alag-alag layers mein tod do. Har
#  layer ka apna ek kaam.
#
#  ------------------------------------------------------------
#  Layer 1: Presentation (Controller)
#  ------------------------------------------------------------
#  Sirf HTTP se input lo, aur application layer ko do. Exception
#  aaye toh HTTP status code (400, 500) mein convert karo.
#
#  class PostController:
#      def __init__(self, service: PostService):
#          self.service = service
#
#      def handle_create(self, request_params: dict):
#          post_request = PostRequest(
#              title=request_params.get("title", ""),
#              content=request_params.get("content", "")
#          )
#          try:
#              post_id = self.service.create(post_request)
#              return 201, "Created", {"Location": f"/posts/{post_id}"}
#          except ValidationException as e:
#              return 400, str(e), {}   # Bad Request
#          except DuplicatePostException as e:
#              return 409, str(e), {}   # Conflict
#
#  Yahan koi business rule nahi hai. Sirf HTTP translation.
#
#  ------------------------------------------------------------
#  Layer 2: Application / Service
#  ------------------------------------------------------------
#  Yeh use case orchestrate karta hai. Validate karta hai, domain
#  object banata hai, aur repository (DB) ko save bolta hai.
#  Yahan asli business logic rehta hai.
#
#  class PostService:
#      def __init__(self, repository: PostRepository, validator: PostValidator, ids: IdGenerator):
#          self.repository = repository
#          self.validator = validator
#          self.ids = ids
#
#      def create(self, request: PostRequest) -> str:
#          self.validator.validate(request)  # Validate
#
#          existing = self.repository.find_by_title(request.title)
#          if existing:
#              raise DuplicatePostException("Title already exists")
#
#          post = Post(  # Domain object banao
#              id=self.ids.new_id(),
#              title=request.title,
#              content=request.content,
#              created_at=datetime.now()
#          )
#          self.repository.save(post)  # DB save
#          return post.id
#
#  Dhyan do: Service sirf interfaces (PostRepository, IdGenerator)
#  pe depend karta hai. Concrete DB (MySQL/Postgres) ki fikar
#  nahi hai.
#
#  ------------------------------------------------------------
#  Layer 3: Domain (Entities)
#  ------------------------------------------------------------
#  Yeh simple data objects hote hain (Post). Inme business rules
#  ho sakte hain, par koi HTTP, DB, ya logging ka code nahi.
#  Sirf entity ka structure.
#
#  class Post:
#      def __init__(self, id, title, content, created_at):
#          self._id = id
#          self._title = title
#          self._content = content
#          self._created_at = created_at
#
#  ------------------------------------------------------------
#  Layer 4: Infrastructure (Repositories, DB, Logging)
#  ------------------------------------------------------------
#  Yeh actual implementation hai. DB se baat karna, file pe log
#  likhna. Yahan ke andar ka code change ho, toh upar wale layers
#  ko farak nahi padta. Interface (PostRepository) define hota hai,
#  usko concrete class (PostgresRepository) implement karti hai.
#
# ============================================================
#
#  4. Fayde (Benefits of SoC)
#  ---------------------------
#  - Better Readability: Har class ek kaam karti hai. Controller
#    padho, DB query samajhne ki zaroorat nahi. Validator padho,
#    HTTP status code nahi dekhne.
#  - Easy Testing: Har component akele test ho sakta hai. Validator
#    ko plain PostRequest do, DB mock nahi karna. Service ko mock
#    repository do.
#  - Maintainability: Ek area change karne se dusre pe asar nahi
#    padta. MySQL se DynamoDB pe shift karo, sirf repository update
#    karna hai. Controller aur service chhede bina.
#  - Team Collaboration: Frontend team controller pe kaam kare,
#    backend team business logic pe. Interface agree kar liya, bas.
#  - Reusability: Same PostValidator REST API aur CLI tool dono
#    mein use ho sakta hai.
#
#  ------------------------------------------------------------
#  Warning: Over-engineering mat karo
#  ------------------------------------------------------------
#  SoC powerful hai, par chhoti apps mein zyada layers ya
#  abstraction mat banao. Agar feature sirf 1-2 classes se ho
#  raha hai, toh simple rakho. Goal clarity hai, ceremony nahi.
#
# ============================================================
#
#  SUMMARY — YAAD RAKHNA
#  ---------------------
#  - Separation of Concerns (SoC) = System ko aise todo ki har part
#    ek distinct concern (zimmedari) sambhaale. "Ek kaam karo, aur
#    achi tarah karo."
#  - Restaurant Analogy: Waiter (Presentation), Chef (Business
#    Logic), Supply Chain (Data Access). Teeno alag.
#  - Problem (God Class): Ek method validation, DB, logging, HTTP
#    sab kar raha hai. Padhna, test karna, maintain karna mushkil.
#  - Solution: Layers mein todo (Controller, Service, Domain,
#    Infrastructure). Har layer apna kaam kare.
#  - Fayde: Readability, Testing easy, Maintainability, Team
#    collaboration, Reusability.
#  - High Cohesion (ek module ke andar sab related) aur Low
#    Coupling (modules independent) SoC se milta hai.
#  - Over-engineering mat karo. Simple features ko simple rakho.
#
#  Ek line mein: SoC = "Ek class, ek kaam. Apne kaam se mat
#  hilna, aur dusre ke kaam mein mat ghusna."
#
# ============================================================
