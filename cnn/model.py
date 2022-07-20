from torch import Tensor
from torch import nn
import torch
from torch._C import StreamObjType


# version 1
# class SpeechDetector(nn.Module):
#     def __init__(self) -> None:
#         super(SpeechDetector, self).__init__()

#         blocks = [
#             nn.Conv1d(1, 32, 250, 100),
#             nn.PReLU(32),

#             nn.Conv1d(32, 64, 150),
#             nn.PReLU(64),

#             nn.Conv1d(64, 128, 100),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 50),
#             nn.PReLU(128),

#             nn.AdaptiveMaxPool1d(5)
#         ]

#         self.network = nn.Sequential(*blocks)


#     def forward(self, x : Tensor) -> Tensor:
#         if len(x.shape) == 2:
#             x = x.view(x.shape[0], 1, x.shape[1])

#         features = self.network(x)
#         result = features.mean((1, 2))

#         return result



# # version 2
# class SpeechDetector(nn.Module):
#     def __init__(self) -> None:
#         super(SpeechDetector, self).__init__()

#         self.device = "cuda" if torch.cuda.is_available() else "cpu"

#         blocks = [
#             nn.Conv1d(1, 32, 250, 100),
#             nn.PReLU(32),

#             nn.Conv1d(32, 64, 150),
#             nn.PReLU(64),

#             nn.Conv1d(64, 128, 100),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 50),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 50),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 50),
#             nn.PReLU(128),
#         ]

#         self.network = nn.Sequential(*blocks)





#     def forward(self, x : Tensor) -> Tensor:
#         if len(x.shape) == 2:
#             x = x.view(x.shape[0], 1, x.shape[1])

#         features = self.network(x)
#         result = features.mean()

#         return result









# # version 3
# class SpeechDetector(nn.Module):
#     def __init__(self) -> None:
#         super(SpeechDetector, self).__init__()

#         self.device = "cuda" if torch.cuda.is_available() else "cpu"

#         blocks = [
#             nn.Conv1d(1, 128, 2000, 800),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 10),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 10),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 10),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 10),
#             nn.PReLU(128),

#             nn.Conv1d(128, 128, 10),
#             nn.PReLU(128),
#         ]

#         self.network = nn.Sequential(*blocks)





#     def forward(self, x : Tensor) -> Tensor:
#         if len(x.shape) == 2:
#             x = x.view(x.shape[0], 1, x.shape[1])

#         features = self.network(x)
#         result = features.mean()
        
#         return result











# version 4
class SpeechDetector(nn.Module):
    def __init__(self) -> None:
        super(SpeechDetector, self).__init__()

        self.device = "cuda" if torch.cuda.is_available() else "cpu"

        blocks = [
            nn.Conv1d(1, 128, 250, 100),
            nn.PReLU(128),
            # nn.ELU(),

            nn.Conv1d(128, 256, 150),
            nn.PReLU(256),
            # nn.ELU(),

            nn.Conv1d(256, 384, 100),
            nn.PReLU(384),
            # nn.ELU(),

            nn.Conv1d(384, 384, 50),
            nn.PReLU(384),
            # nn.ELU(),

            nn.Conv1d(384, 512, 50),
            nn.PReLU(512),
            # nn.ELU(),

            nn.Conv1d(512, 512, 50),
            nn.PReLU(512),
            # nn.ELU(),
        ]

        self.network = nn.Sequential(*blocks)





    def forward(self, x : Tensor) -> Tensor:
        if len(x.shape) == 2:
            x = x.view(x.shape[0], 1, x.shape[1])

        features = self.network(x)
        predictedsnr = features.mean()

        predictedsnrdb = 20 * torch.log10(predictedsnr)
        
        return predictedsnrdb






# statblocks = [
#     nn.Linear(2, 10),
#     nn.PReLU(),

#     nn.Linear(10, 10),
#     nn.PReLU(),

#     nn.Linear(10, 10),
#     nn.PReLU(),

#     nn.Linear(10, 10),
#     nn.PReLU(),

#     nn.Linear(10, 1),
# ]

# self.stat_nn = nn.Sequential(*statblocks)